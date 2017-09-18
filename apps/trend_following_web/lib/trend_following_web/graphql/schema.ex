defmodule TrendFollowingWeb.Graphql.Schema do
  use Absinthe.Schema

  import_types TrendFollowingWeb.Graphql.Types.Dayk
  import_types TrendFollowingWeb.Graphql.Types.Stock
  import_types TrendFollowingWeb.Graphql.Types.Future
  
  query do
    field :dayk, list_of(:dayk) do
      arg :symbol, non_null(:string), description: "股票代码"
      resolve &TrendFollowingWeb.Graphql.Resolver.Dayk.all/2
    end

    field :cn_stock, :cn_stock do
      arg :symbol, non_null(:string), description: "股票代码"
      resolve &TrendFollowingWeb.Graphql.Resolver.Stock.cn_stock/2
    end

    field :hk_stock, :hk_stock do
      arg :symbol, non_null(:string), description: "股票代码"
      resolve &TrendFollowingWeb.Graphql.Resolver.Stock.hk_stock/2
    end

    field :us_stock, :us_stock do
      arg :symbol, non_null(:string), description: "股票代码"
      resolve &TrendFollowingWeb.Graphql.Resolver.Stock.us_stock/2
    end

    field :i_future, :i_future do
      arg :symbol, non_null(:string), description: "期货代码"
      resolve &TrendFollowingWeb.Graphql.Resolver.Future.i_future/2
    end

    field :g_future, :g_future do
      arg :symbol, non_null(:string), description: "期货代码"
      resolve &TrendFollowingWeb.Graphql.Resolver.Future.g_future/2
    end
  end
end