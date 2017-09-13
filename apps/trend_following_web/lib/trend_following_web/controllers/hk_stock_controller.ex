defmodule TrendFollowingWeb.HKStockController do
  use TrendFollowingWeb, :controller

  alias TrendFollowing.Markets

  def index(conn, params) do
    market =
      case Map.get(params, "tab", "all") do
        "all" -> :hk
        "bull" -> :hk_bull
        "bear" -> :hk_bear
      end

    page = Markets.stock_paginate(market, params)

    conn
    |> assign(:title, "港股")
    |> assign(:params, params)
    |> assign(:page, page)
    |> render(:index)
  end

  def show(conn, %{"symbol" => symbol}) do
    stock = Markets.get_stock!(symbol)

    conn
    |> assign(:stock, stock)
    |> render(:show)
  end
end
