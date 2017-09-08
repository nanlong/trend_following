defmodule TrendFollowingJob.StockDetail do
  alias TrendFollowing.Markets

  def load(market, symbol) do
    %{body: data} = detail_data(market, symbol)
    attrs = data_handler(market, data)
    stock = Markets.get_stock(symbol)
    Markets.update_stock(stock, attrs)
  end

  def detail_data(:cn, symbol), do: TrendFollowingApi.Sina.CNStock.get("detail", symbol: symbol)
  def detail_data(:hk, symbol), do: TrendFollowingApi.Sina.HKStock.get("detail", symbol: symbol)

  def data_handler(:cn, data) do
    %{
      market_cap: Map.get(data, "market_cap") |> to_string(),
      pe: Map.get(data, "pe") |> to_string()
    }
  end
  def data_handler(:hk, data) do
    %{
      market_cap: Map.get(data, "hk_market_cap") |> to_string(),
      pe: Map.get(data, "pe") |> to_string(),
      lot_size: Map.get(data, "lot_size")
    }
  end
end