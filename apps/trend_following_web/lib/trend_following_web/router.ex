defmodule TrendFollowingWeb.Router do
  use TrendFollowingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_session do
    plug Guardian.Plug.Pipeline, module: TrendFollowingWeb.Helpers.Guardian
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource, allow_blank: true
    plug TrendFollowingWeb.Helpers.CurrentUser
  end

  pipeline :browser_required_signin do
    plug Guardian.Plug.Pipeline, module: TrendFollowingWeb.Helpers.Guardian,
      error_handler: TrendFollowingWeb.Helpers.AuthErrorHandler
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug TrendFollowingWeb.Helpers.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TrendFollowingWeb do
    pipe_through [:browser, :browser_session]

    get "/", PageController, :index
    
    get "/signup", UserController, :new
    post "/signup", UserController, :create

    get "/signin", SessionController, :new
    post "/signin", SessionController, :create

    resources "/password_reset", PasswordResetController, only: [:show, :create, :update], singleton: true
  end

  scope "/", TrendFollowingWeb do
    pipe_through [:browser, :browser_required_signin] # Use the default browser stack

    delete "/signout", SessionController, :delete

    get "/settings", SettingController, :index
    resources "/settings/:page", SettingController, only: [:show, :update], singleton: true

    resources "/market", MarketController, singleton: true, only: [:show] do
      resources "/CN_Stocks", CNStockController, param: "symbol", only: [:index, :show] do
        get "/position", PositionController, :show
        get "/backtest", BacktestController, :show
      end
      
      resources "/HK_Stocks", HKStockController, param: "symbol", only: [:index, :show] do
        get "/position", PositionController, :show
        get "/backtest", BacktestController, :show
      end

      resources "/US_Stocks", USStockController, param: "symbol", only: [:index, :show] do
        get "/position", PositionController, :show
        get "/backtest", BacktestController, :show
      end

      resources "/I_Futures", IFutureController, param: "symbol", only: [:index, :show] do
        get "/position", PositionController, :show
        get "/backtest", BacktestController, :show
      end

      resources "/G_Futures", GFutureController, param: "symbol", only: [:index, :show] do
        get "/position", PositionController, :show
        get "/backtest", BacktestController, :show
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
