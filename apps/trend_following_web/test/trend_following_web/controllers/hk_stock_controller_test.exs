defmodule TrendFollowingWeb.HKStockControllerTest do
  use TrendFollowingWeb.ConnCase

  test "index", %{conn: conn} do
    conn = get conn, market_hk_stock_path(conn, :index)
    assert html_response(conn, 200) =~ "港股"
  end
end
