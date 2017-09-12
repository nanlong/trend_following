defmodule TrendFollowingWeb.MarketController do
  use TrendFollowingWeb, :controller

  def show(conn, _params) do
    redirect(conn, to: "/")
  end
end