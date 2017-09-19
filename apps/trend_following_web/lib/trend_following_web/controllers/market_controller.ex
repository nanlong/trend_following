defmodule TrendFollowingWeb.MarketController do
  use TrendFollowingWeb, :controller

  def show(conn, _params) do
    redirect(conn, to: market_cn_stock_path(conn, :index))
  end
end