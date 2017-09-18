defmodule TrendFollowingWeb.USStockController do
  use TrendFollowingWeb, :controller

  alias TrendFollowing.Markets

  def index(conn, params) do
    market =
      case Map.get(params, "tab", "all") do
        "all" -> :us
        "bull" -> :us_bull
        "bear" -> :us_bear
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

    js_config = %{
      symbol: symbol,
      trend: Markets.trend(stock.dayk),
    }

    conn
    |> assign(:title, stock.cname)
    |> assign(:stock, stock)
    |> assign(:js_config, js_config)
    |> render(:show)
  end
end
