defmodule TrendFollowingWeb.Graphql.Resolver.Dayk do
  alias TrendFollowing.Markets

  def all(%{symbol: symbol}, _info) do
    data = Markets.list_dayk(symbol)
    {:ok, data}
  end
end