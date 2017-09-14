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

    resources "/market", MarketController, singleton: true, only: [:show] do
      resources "/CN_Stocks", CNStockController, param: "symbol", only: [:index, :show] do
        get "/backtest", BacktestController, :show
        get "/position", PositionController, :show
      end
      
      resources "/HK_Stocks", HKStockController, param: "symbol", only: [:index, :show] do
        get "/backtest", BacktestController, :show
        get "/position", PositionController, :show
      end

      resources "/US_Stocks", USStockController, param: "symbol", only: [:index, :show] do
        get "/backtest", BacktestController, :show
        get "/position", PositionController, :show
      end
    end
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
