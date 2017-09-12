defmodule TrendFollowingData.Sina.IFuture do
  @moduledoc """
  TrendFollowingData.Sina.IFuture.get("list")
  TrendFollowingData.Sina.IFuture.get("detail", symbol: "TA0")
  TrendFollowingData.Sina.IFuture.get("dayk", symbol: "TA0")
  TrendFollowingData.Sina.IFuture.get("info", symbol: "TA0")
  """
  use HTTPotion.Base
  alias TrendFollowingData.Sina.IFuture

  @list_api "http://gu.sina.cn/hq/api/openapi.php/FuturesService.getInner"
  @dayk_api "http://stock2.finance.sina.com.cn/futures/api/jsonp.php/data/InnerFuturesNewService.getDailyKLine"
  @detail_url "http://finance.sina.com.cn/futures/quotes/<%= @symbol %>.shtml"
  @detail_api "http://hq.sinajs.cn"

  def process_url("list", _query) do
    @list_api
  end

  def process_url("dayk", query) do
    query = [
      symbol: Keyword.get(query, :symbol)
    ]

    process_url(@dayk_api, query)
  end

  def process_url("info", query) do
    query = [
      symbol: Keyword.get(query, :symbol)
    ]
    EEx.eval_string(@detail_url, assigns: query)
  end

  def process_url("detail", query) do
    rn = (System.system_time() / 1_000_000_000) |> round()
    list = "nf_#{query[:symbol]}"
    @detail_api <> "/?rn=#{rn}&list=#{list}"
  end

  def process_url(url, query) do
    process_url(url)
    |> prepend_protocol
    |> append_query_string([query: query])
  end

  def process_response_body(body) do
    body = :iconv.convert("gbk", "utf-8", body)
    
    {:ok, data} =
      body
      |> IO.iodata_to_binary()
      |> decode()

    data
  end

  def decode("data" <> data) do
    data = String.slice(data, 1..-3)

    ~r/(?<={|,)\w+(?=:)/
    |> Regex.replace(data, "\"\\g{0}\"")
    |> Poison.decode()
  end

  def decode("<!DOCTYPE html" <> _ = html) do
    name = 
      html
      |> Floki.find(".futures-title .title")
      |> Floki.text()

    data =
      case name do
        "纤维板" ->
          %{
            "lot_size" => 500,
            "price_quote" => "元",
            "trading_unit" => "张",
            "minimum_price_change" => "0.05元"
          }
        _ ->
          lot_size_data =
            html
            |> Floki.find("table#table-futures-basic-data tr:nth-child(1) td:nth-child(4)")
            |> Floki.text() 
      
          lot_size =
            Regex.named_captures(~r/(?<lot_size>\d+)/, lot_size_data)
            |> Map.get("lot_size")
            |> String.to_integer()
      
          minimum_price_change = 
            html
            |> Floki.find("table#table-futures-basic-data tr:nth-child(2) td:nth-child(2)")
            |> Floki.text() 
      
          {minimum_price_change, trading_unit} = String.split(minimum_price_change, "/") |> List.to_tuple()
      
          %{
            "lot_size" => lot_size,
            "price_quote" => "元",
            "trading_unit" => trading_unit,
            "minimum_price_change" => minimum_price_change
          }
      end
    
    {:ok, data}
  end

  def decode("var hq_str_nf_" <> _ = data) do
    %{"symbol" => symbol} = Regex.named_captures(~r/nf_(?<symbol>.+)=/, data)
    %{"data" => data} = Regex.named_captures(~r/"(?<data>.*)"/, data)
    data = data |> String.split(",") |> List.to_tuple()

    {open, _} = elem(data, 2) |> Float.parse()
    {highest, _} = elem(data, 3) |> Float.parse()
    {lowest, _} = elem(data, 4) |> Float.parse()
    {price, _} = elem(data, 6) |> Float.parse()
    {sell_price, _} = elem(data, 7) |> Float.parse()
    {buy_price, _} = elem(data, 8) |> Float.parse()
    {close, _} = elem(data, 9) |> Float.parse()
    {pre_close, _} = elem(data, 10) |> Float.parse()
    {buy_positions, _} = elem(data, 11) |> Integer.parse()
    {sell_positions, _} = elem(data, 12) |> Integer.parse()
    {open_positions, _} = elem(data, 13) |> Integer.parse()
    {volume, _} = elem(data, 14) |> Integer.parse()

    time = elem(data, 1) |> String.graphemes() |> Enum.chunk_every(2) |> Enum.map(fn(x) -> Enum.join(x) end) |> Enum.join(":")
    name = elem(data, 0)
    datetime = "#{elem(data, 17)} #{time}"
    diff = price - pre_close |> Float.round(2)
    chg = diff / pre_close * 100 |> Float.round(2)
    
    info = IFuture.get("info", symbol: symbol, timeout: 10_000) |> Map.get(:body) 
      
    {:ok, %{
      "symbol" => symbol,
      "name" => name,
      "lot_size" => Map.get(info, "lot_size"),
      "price" => price,
      "open" => open,
      "highest" => highest,
      "lowest" => lowest,
      "close" => close,
      "pre_close" => pre_close,
      "volume" => volume,
      "diff" => diff,
      "chg" => chg,
      "buy_price" => buy_price,
      "sell_price" => sell_price,
      "open_positions" => open_positions,
      "buy_positions" => buy_positions,
      "sell_positions" => sell_positions,
      "trading_unit" => Map.get(info, "trading_unit"),
      "price_quote" => Map.get(info, "price_quote"),
      "minimum_price_change" => Map.get(info, "minimum_price_change"),
      "datetime" => datetime,
    }}
  end

  def decode(data) do
    Poison.decode(data)
  end
end