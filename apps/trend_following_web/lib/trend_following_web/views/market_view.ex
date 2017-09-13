defmodule TrendFollowingWeb.MarketView do
  use TrendFollowingWeb, :view

  def panel(conn) do
    [
      {"沪深", "", ""},
      {"港股", "HKStockController", market_hk_stock_path(conn, :index)},
      {"美股", "", ""},
      {"国内期货", "if", ""},
      {"外盘期货", "gf", ""},
    ]
  end

  def controller_module(conn) do
    Phoenix.Controller.controller_module(conn)
    |> to_string()
    |> String.split(".")
    |> List.last()
  end
end