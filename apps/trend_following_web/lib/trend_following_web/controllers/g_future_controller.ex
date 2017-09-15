defmodule TrendFollowingWeb.GFutureController do
  use TrendFollowingWeb, :controller

  alias TrendFollowing.Markets
  alias TrendFollowing.Markets.GFuture

  def index(conn, _params) do
    data = Markets.list_future(:g)

    conn
    |> assign(:title, "外盘期货")
    |> assign(:data, data)
    |> render(:index)
  end

  def show(conn, %{"symbol" => symbol}) do
    future = Markets.get_future(symbol)

    js_config = %{
      symbol: symbol
    }

    conn
    |> assign(:title, future.name)
    |> assign(:future, future)
    |> assign(:js_config, js_config)
    |> render(:show)
  end
end
