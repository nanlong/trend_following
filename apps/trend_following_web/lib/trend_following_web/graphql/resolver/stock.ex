defmodule TrendFollowingWeb.Graphql.Resolver.Stock do
  alias TrendFollowingData.Sina.HKStock

  def hk_stock(%{symbol: symbol}, _info) do
    %{status_code: 200, body: data} = HKStock.get("detail", symbol: symbol)
    {:ok, map_keys_string_to_atom(data)}
  end

  defp map_keys_string_to_atom(map) do
    for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}
  end
end