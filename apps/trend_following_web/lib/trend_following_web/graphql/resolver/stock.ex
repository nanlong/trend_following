defmodule TrendFollowingWeb.Graphql.Resolver.Stock do
  alias TrendFollowingData.Sina.CNStock
  alias TrendFollowingData.Sina.HKStock
  alias TrendFollowingData.Sina.USStock


  def cn_stock(%{symbol: symbol}, _info) do
    %{status_code: 200, body: data} = CNStock.get("detail", symbol: symbol)

    data = 
      data
      |> map_keys_string_to_atom()
      |> Map.put(:timestamp, timestamp())

    {:ok, data}
  end

  def hk_stock(%{symbol: symbol}, _info) do
    %{status_code: 200, body: data} = HKStock.get("detail", symbol: symbol)

    data = 
      data
      |> map_keys_string_to_atom()
      |> Map.put(:timestamp, timestamp())

    {:ok, data}
  end

  def us_stock(%{symbol: symbol}, _info) do
    %{status_code: 200, body: data} = USStock.get("detail", symbol: symbol)

    data = 
      data
      |> map_keys_string_to_atom()
      |> Map.put(:timestamp, timestamp())

    {:ok, data}
  end

  defp map_keys_string_to_atom(map) do
    for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}
  end

  defp timestamp do
    System.system_time() / 1_000_000_000 |> round()
  end
end