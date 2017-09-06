defmodule TrendFollowingWeb.PageController do
  use TrendFollowingWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
