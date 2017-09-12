defmodule TrendFollowingJob.StockDetail do
  @moduledoc """
    TrendFollowingJob.StockDetail.load("cn", "sh600419")
    TrendFollowingJob.StockDetail.load("hk", "00700")
  """
  alias TrendFollowing.Markets

  def perform(market, symbol) do
    load(market, symbol)
    Exq.enqueue(Exq, "default", TrendFollowingJob.Dayk, [market, symbol])
  end

  def load(market, symbol) do
    %{body: data} = detail_data(market, symbol)
    attrs = data_handler(market, data)
    stock = Markets.get_stock(symbol)
    Markets.update_stock(stock, attrs)
  end

  def detail_data("cn", symbol), do: TrendFollowingData.Sina.CNStock.get("detail", symbol: symbol)
  def detail_data("hk", symbol), do: TrendFollowingData.Sina.HKStock.get("detail", symbol: symbol)

  def data_handler("cn", data) do
    market_cap =
      data
      |> Map.get("market_cap", 0.0)
      |> :erlang.float_to_binary(decimals: 2)
      
    %{
      market_cap: market_cap,
      pe: Map.get(data, "pe", 0) |> to_string()
    }
  end
  def data_handler("hk", data) do
    market_cap =
      data
      |> Map.get("hk_market_cap", 0.0)
      |> :erlang.float_to_binary(decimals: 2)

    %{
      market_cap: market_cap,
      pe: Map.get(data, "pe", 0) |> to_string(),
      lot_size: Map.get(data, "lot_size")
    }
  end
end