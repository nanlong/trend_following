defmodule TrendFollowingWeb.Router do
  use TrendFollowingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TrendFollowingWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/markets", MarketController, singleton: true, only: [:show] do
      resources "/HK_Stocks", HKStockController, param: "symbol", only: [:index, :show]
    end

    get "/stocks/:symbol/backtest", StockBacktestController, :show
  end

  scope "/api" do
    # pipe_through [:graphql]

    forward "/", Absinthe.Plug,
      schema: TrendFollowingWeb.Graphql.Schema
  end

  scope "/graphiql" do
    forward "/", Absinthe.Plug.GraphiQL,
      schema: TrendFollowingWeb.Graphql.Schema
  end

  # Other scopes may use custom stacks.
  # scope "/api", TrendFollowingWeb do
  #   pipe_through :api
  # end
end
