defmodule TrendFollowingJob.Future do
  @moduledoc """
  TrendFollowingJob.Future.load("i")
  TrendFollowingJob.Future.load("g")
  """
  alias TrendFollowing.Markets

  def perform(market) do
    callback = 
      fn(market, symbol) -> 
        Exq.enqueue(Exq, "default", TrendFollowingJob.FutureDetail, [market, symbol])
      end

    load(market, callback)
  end

  def load(market, fun \\ fn(_market, _symbol) -> nil end) do
    %{status_code: 200, body: data} = future_data(market)
    
    market
    |> data_handler(data)
    |> Enum.map(fn(attrs) -> 
      {:ok, future} =
        case Markets.get_future(attrs.symbol) do
          nil -> Markets.create_future(attrs)
          future -> {:ok, future}
        end
      
      fun.(market, future.symbol)
    end)
  end

  defp future_data("i"), do: TrendFollowingData.Sina.IFuture.get("list")
  defp future_data("g"), do: TrendFollowingData.Sina.GFuture.get("list")

  defp data_handler("i", data) do
    czce = get_in(data, ["result", "data", "czce"])
    dec = get_in(data, ["result", "data", "dce"])
    shfe = get_in(data, ["result", "data", "shfe"])

    Enum.concat([czce, dec, shfe])
    |> Enum.map(fn(x) -> 
      %{
        symbol: Map.get(x, "symbol"),
        name: Map.get(x, "contract"),
        market: Map.get(x, "market") |> String.upcase()
      }
    end)
  end
  defp data_handler("g", data) do
    data
    |> get_in(["result", "data", "global_good"])
    |> Enum.map(fn(x) -> 
      %{
        symbol: Map.get(x, "symbol"),
        name: Map.get(x, "symbol"),
        market: "GLOBAL"
      }
    end)
  end
end