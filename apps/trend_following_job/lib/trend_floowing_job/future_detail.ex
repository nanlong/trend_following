defmodule TrendFollowingJob.FutureDetail do
  @moduledoc """
  TrendFollowingJob.FutureDetail.load("i", "TA0")
  TrendFollowingJob.FutureDetail.load("g", "CL")
  """
  alias TrendFollowing.Markets

  def perform(market, symbol) do
    load(market, symbol)
    Exq.enqueue(Exq, "default", TrendFollowingJob.Dayk, [market, symbol])
  end

  def load(market, symbol) do
    %{status_code: 200, body: data} = detail_data(market, symbol)
    data = data_handler(market, data)

    case Markets.get_future(symbol) do
      nil -> nil
      future -> Markets.update_future(future, data)
    end
  end

  defp detail_data("i", symbol), do: TrendFollowingData.Sina.IFuture.get("detail", symbol: symbol)
  defp detail_data("g", symbol), do: TrendFollowingData.Sina.GFuture.get("detail", symbol: symbol)

  defp data_handler("i", data) do
    %{
      lot_size: Map.get(data, "lot_size"),
      trading_unit: Map.get(data, "trading_unit"),
      price_quote: Map.get(data, "price_quote"),
      minimum_price_change: Map.get(data, "minimum_price_change")
    }
  end
  defp data_handler("g", data) do
    %{
      name: Map.get(data, "name"),
      lot_size: Map.get(data, "lot_size"),
      trading_unit: Map.get(data, "trading_unit"),
      price_quote: Map.get(data, "price_quote"),
      minimum_price_change: Map.get(data, "minimum_price_change")
    }
  end
end