defmodule TrendFollowingWeb.HKStockController do
  use TrendFollowingWeb, :controller

  alias TrendFollowing.Markets

  def index(conn, params) do
    page = Markets.stock_paginate(:hk, params)

    conn
    |> assign(:title, "港股")
    |> assign(:params, params)
    |> assign(:page, page)
    |> render(:index)
  end

  def show(conn, %{"symbol" => symbol}) do
    
    conn
    |> render(:show)
  end
end
