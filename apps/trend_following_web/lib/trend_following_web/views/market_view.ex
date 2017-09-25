defmodule TrendFollowingWeb.MarketView do
  use TrendFollowingWeb, :view

  def panel(conn) do
    [
      {"沪深", "CNStockController", market_cn_stock_path(conn, :index)},
      {"港股", "HKStockController", market_hk_stock_path(conn, :index)},
      {"美股", "USStockController", market_us_stock_path(conn, :index)},
      {"国内期货", "IFutureController", market_i_future_path(conn, :index)},
      {"外盘期货", "GFutureController", market_g_future_path(conn, :index)},
    ]
  end
end