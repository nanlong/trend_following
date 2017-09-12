defmodule TrendFollowingData.Sina.USStock do
  @moduledoc """
  TrendFollowingData.Sina.USStock.get("list", page: 1)
  TrendFollowingData.Sina.USStock.get("dayk", symbol: "AAPL")
  TrendFollowingData.Sina.USStock.get("mink", symbol: "AAPL", type: 5)
  TrendFollowingData.Sina.USStock.get("detail", symbol: "AAPL")
  """
  use HTTPotion.Base

  @k_service "http://stock.finance.sina.com.cn/usstock/api/jsonp_v2.php/<%= @varible %>/US_MinKService.<%= @method %>"
  @category_service "http://stock.finance.sina.com.cn/usstock/api/jsonp.php/List/US_CategoryService.<%= @method %>"
  @realtime_api "http://hq.sinajs.cn/"

  def process_url("list", query) do
    url = EEx.eval_string(@category_service, assigns: [method: "getList"])
    process_url(url, query)
  end
  
  def process_url("dayk", query) do
    url = EEx.eval_string(@k_service, assigns: [varible: "DailyK", method: "getDailyK"])
    process_url(url, query)
  end
  
  def process_url("mink", query) do
    url = EEx.eval_string(@k_service, assigns: [varible: "MinK", method: "getMinK"])
    process_url(url, query)
  end

  def process_url("detail", query) do
    @realtime_api <> "/?list=usr_" <> String.downcase(query[:symbol])
  end
  
  def process_url(url, query) do
    process_url(url)
    |> prepend_protocol
    |> append_query_string([query: query])
  end

  def process_response_body(body) when is_list(body), do: :iconv.convert("gbk", "utf-8", body) |> process_response_body
  def process_response_body(body), do: body |> IO.iodata_to_binary |> to_json

  defp to_json("List(null);"), do: []
  defp to_json("DailyK(null);"), do: []
  defp to_json("MinK(null);"), do: []
  defp to_json("var hq_str" <> _ = data) do
    # 中文名称 cname
    # 价格 price
    # 涨跌额 diff
    # 时间 datetime
    # 涨跌幅 chg
    # 开盘价 open
    # 最高价 high
    # 最低价 low
    # 52周最高 year_high
    # 52周最低 year_low
    # 成交量 volume
    # 10日均量 volume_10_avg
    # 市值 market_cap
    # 每股收益 eps
    # 市盈率 pe
    # --
    # 贝塔系数 beta
    # 股息 dividend
    # 收益率 yield
    # 股本 capital
    # --
    # 盘前价格
    # 盘前涨跌幅
    # 盘前涨跌额
    # 盘前时间
    # 前日收盘时间
    # 前收盘价格 
    # 盘前成交量

    # ["苹果", "144.1800", "1.02", "2017-07-08 08:19:19", "1.4500", "142.9000",
    # "144.7500", "142.9000", "156.6500", "96.4200", "19201712", "23030822",
    # "756945000000", "8.33", "17.31", "0.00", "1.44", "2.28", "1.60", "5250000000",
    # "63.00", "144.2500", "0.05", "0.07", "Jul 07 08:00PM EDT",
    # "Jul 07 04:00PM EDT", "142.7300", "892519.00"]

    %{"symbol" => symbol} = Regex.named_captures(~r/str_(?<symbol>\w+)=/, data)
    [[_, data]] = Regex.scan(~r/"(.*)"/, data)

    keys = 
      ["cname", "price", "diff", "datetime", "chg", "open",
      "high", "low", "year_high", "year_low", "volume", "volume_d10_avg",
      "market_cap", "eps", "pe", nil, "beta", "dividend", "yield", "capital",
        nil, nil, nil, nil, nil,
      "pre_close_datetime", "pre_close", nil]

    Enum.zip(["symbol"] ++ keys, [symbol] ++ String.split(data, ","))
    |> Enum.into(%{})
    |> Map.delete(:nil)
  end
  defp to_json("List" <> data), do: data |> decode_json
  defp to_json("DailyK" <> data), do: data |> decode_json
  defp to_json("MinK" <> data), do: data |> decode_json
  defp to_json(data), do: data |> Poison.decode

  defp decode_json("((" <> data) do
    data = 
      data
      |> String.slice(0..-4)
      |> String.replace("null", "\"null\"")
      |> String.replace("\\'", "\'")
    
    ~r/(?<={|,)\w+(?=:)/
    |> Regex.replace(data, "\"\\g{0}\"")
    |> Poison.decode
    |> elem(1)
  end

  defp decode_json(data) do
    data = 
      data
      |> String.slice(1..-3)
      
    ~r/(?<={|,)\w+(?=:)/
    |> Regex.replace(data, "\"\\g{0}\"")
    |> Poison.decode
    |> elem(1)
  end
end