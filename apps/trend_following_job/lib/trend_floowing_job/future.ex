defmodule TrendFollowingJob.Future do
  @moduledoc """
  TrendFollowingJob.Future.load("i")
  TrendFollowingJob.Future.load("g")
  """
  alias TrendFollowing.Markets

  def load(market) do
    %{status_code: 200, body: data} = future_data(market)
    
    market
    |> data_handler(data)
    |> Enum.map(fn(attrs) -> 
      future =
        case Markets.get_future(attrs.symbol) do
          nil -> Markets.create_future(attrs)
          future -> future
        end

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