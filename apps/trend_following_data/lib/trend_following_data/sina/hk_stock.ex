defmodule TrendFollowingData.Sina.HKStock do
  @moduledoc """
  TrendFollowingData.Sina.HKStock.get("list", page: 1)
  TrendFollowingData.Sina.HKStock.get("dayk", symbol: "00700")
  TrendFollowingData.Sina.HKStock.get("lotSize", symbol: "00700")
  TrendFollowingData.Sina.HKStock.get("detail", symbol: "00700")
  """

  use HTTPotion.Base
  alias TrendFollowingData.Sina.Decode
  alias TrendFollowingData.Sina.HKStock

  @list_api "http://vip.stock.finance.sina.com.cn/quotes_service/api/json_v2.php/Market_Center.getHKStockData"
  @dayk_api "http://finance.sina.com.cn/stock/hkstock/<%= @symbol %>/klc_kl.js"
  @lot_size_url "http://stock.finance.sina.com.cn/hkstock/quotes/<%= @symbol %>.html"
  @detail_api "http://hq.sinajs.cn"

  def process_url("list", query) do
    query = [
      page: Keyword.get(query, :page, 1),
      num: Keyword.get(query, :num, 40),
      sort: Keyword.get(query, :sort, "symbol"),
      asc: Keyword.get(query, :asc, 1),
      node: Keyword.get(query, :node, "qbgg_hk")
    ]

    process_url(@list_api, query)
  end

  def process_url("dayk", query) do
    symbol = Keyword.get(query, :symbol)
    EEx.eval_string(@dayk_api, assigns: [symbol: symbol])
  end

  def process_url("lotSize", query) do
    query = [
      symbol: Keyword.get(query, :symbol)
    ]
    EEx.eval_string(@lot_size_url, assigns: query)
  end

  def process_url("detail", query) do
    rn = (System.system_time() / 1_000_000_000) |> round()
    list = "rt_hk#{query[:symbol]},hk#{query[:symbol]}_i"
    @detail_api <> "/?_=#{rn}&list=#{list}"
  end

  def process_url(url, query) do
    process_url(url)
    |> prepend_protocol
    |> append_query_string([query: query])
  end

  def process_response_body(body) do
    :iconv.convert("gbk", "utf-8", body) 
    |> IO.iodata_to_binary()
    |> decode()
  end

  def decode("var KLC_KL_" <> _ = data) do
    ~r/var\sKLC_KL_[0-9]+=\"(?<data>\S+)";/
    |> Regex.named_captures(data)
    |> Map.get("data")
    |> Decode.decode()
  end

  def decode("var hq_str" <> _ = data) do
    %{"symbol" => symbol} = Regex.named_captures(~r/hk(?<symbol>\d+)=/, data)
    [[_, d1], [_, d2]] = Regex.scan(~r/"(.*)"/, data)

    if String.length(d1) <= 0 or String.length(d2) <= 0 do
      %{}
    else
      d1 = String.split(d1, ",") |> List.to_tuple()
      d2 = String.split(d2, ",") |> List.to_tuple()

      {open, _} = float_parse(d1, 2)
      {pre_close, _} = float_parse(d1, 3)
      {highest, _} = float_parse(d1, 4)
      {lowest, _} = float_parse(d1, 5)
      {price, _} = float_parse(d1, 6)
      {diff, _} = float_parse(d1, 7)
      {chg, _} = float_parse(d1, 8)
      {pe, _} = float_parse(d1, 13)
      # 成交额
      {amount, _} = float_parse(d1, 11)
      # 成交量
      {volume, _} = integer_parse(d1, 12)
      # 52周最高
      {year_highest, _} = float_parse(d1, 15)
      # 52周最低
      {year_lowest, _} = float_parse(d1, 16)
      # 港股股本
      {hk_capital, _} = integer_parse(d2, 7)
      # 总股本
      {total_capital, _} = integer_parse(d2, 9)
      # 周息率
      {dividend_yield, _} = float_parse(d2, 10)
      # 振幅
      amplitude = if pre_close == 0, do: 0.0, else: ((highest - lowest) / pre_close * 100) |> Float.round(3)
      # 港股市值
      hk_market_cap = (price * hk_capital) |> Float.round(3)
      datetime = "#{elem(d1, 17)} #{elem(d1, 18)}"

      lot_size = 
        HKStock.get("lotSize", symbol: symbol) 
        |> Map.get(:body)
        |> Map.get("lot_size", 0)

      %{
        "symbol" => symbol,
        "name" => elem(d1, 0),
        "cname" => elem(d1, 1),
        "lot_size" => lot_size,
        "price" => price,
        "diff" => diff,
        "chg" => chg,
        "pre_close" => pre_close,
        "open" => open,
        "amount" => amount,
        "volume" => volume,
        "high" => highest,
        "low" => lowest,
        "year_high" => year_highest,
        "year_low" => year_lowest,
        "amplitude" => amplitude,
        "pe" => pe,
        "total_capital" => total_capital,
        "hk_capital" => hk_capital,
        "hk_market_cap" => hk_market_cap,
        "dividend_yield" => dividend_yield |> Float.round(3),
        "datetime" => datetime,
      }
    end
  end

  def decode("<!doctype html>" <> _string = html) do
    selector = "div.stock_detail div.deta03 ul:nth-child(2) li.last span"

    lot_size =
      html
      |> Floki.find(selector)
      |> Floki.text() 
      |> String.to_integer()

    %{"lot_size" => lot_size}
  end

  def decode(data) do
    try do
      data = String.replace(data, "\\'", "\'")

      {:ok, data} =
        ~r/(?<={|,)\w+(?=:)/
        |> Regex.replace(data, "\"\\g{0}\"")
        |> Poison.decode()

      data
    rescue
      _ -> %{}
    end
  end

  defp float_parse(tuple, index), do: "0" <> elem(tuple, index) |> Float.parse()
  defp integer_parse(tuple, index), do: "0" <> elem(tuple, index) |> Integer.parse()
end