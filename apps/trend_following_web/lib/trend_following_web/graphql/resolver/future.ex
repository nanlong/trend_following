defmodule TrendFollowingWeb.Graphql.Resolver.Future do
  alias TrendFollowingData.Sina.IFuture
  alias TrendFollowingData.Sina.GFuture


  def i_future(%{symbol: symbol}, _info) do
    %{status_code: 200, body: data} = IFuture.get("detail", symbol: symbol)

    data = 
      data
      |> map_keys_string_to_atom()
      |> Map.put(:timestamp, timestamp())

    {:ok, data}
  end

  def g_future(%{symbol: symbol}, _info) do
    %{status_code: 200, body: data} = GFuture.get("detail", symbol: symbol)

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