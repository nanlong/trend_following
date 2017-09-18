defmodule TrendFollowingWeb.GFutureController do
  use TrendFollowingWeb, :controller

  alias TrendFollowing.Markets

  def index(conn, params) do
    market =
      case Map.get(params, "tab", "all") do
        "all" -> :g
        "bull" -> :g_bull
        "bear" -> :g_bear
      end

    data = Markets.list_future(market)

    conn
    |> assign(:title, "外盘期货")
    |> assign(:data, data)
    |> assign(:params, params)
    |> render(:index)
  end

  def show(conn, %{"symbol" => symbol}) do
    future = Markets.get_future(symbol)

    js_config = %{
      symbol: symbol,
      trend: Markets.trend(future.dayk),
    }

    conn
    |> assign(:title, future.name)
    |> assign(:future, future)
    |> assign(:js_config, js_config)
    |> render(:show)
  end
end
