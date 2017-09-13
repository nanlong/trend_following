defmodule TrendFollowingWeb.Graphql.Schema do
  use Absinthe.Schema

  import_types TrendFollowingWeb.Graphql.Types.Dayk
  
  query do
    field :dayk, list_of(:dayk) do
      arg :symbol, non_null(:string), description: "股票代码"
      resolve &TrendFollowingWeb.Graphql.Resolver.Dayk.all/2
    end
  end
end