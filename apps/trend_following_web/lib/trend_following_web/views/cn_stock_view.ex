defmodule TrendFollowingWeb.CNStockView do
  use TrendFollowingWeb, :view

  def tabs_data(conn) do
    [
      {"全部", "all", market_cn_stock_path(conn, :index, tab: "all")},
      {"适合做多的", "bull", market_cn_stock_path(conn, :index, tab: "bull")},
      {"适合做空的", "bear", market_cn_stock_path(conn, :index, tab: "bear")},
    ]
  end
end
