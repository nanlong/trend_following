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

    resources "/markets", MarketController, singleton: true, only: [:show]

    get "/stocks/:symbol/backtest", StockBacktestController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", TrendFollowingWeb do
  #   pipe_through :api
  # end
end
