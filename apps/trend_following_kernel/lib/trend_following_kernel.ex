defmodule TrendFollowingKernel do
  alias TrendFollowingKernel.Position
  alias TrendFollowingKernel.Backtest

  defdelegate position(system, trade, dayk, config), to: Position
  defdelegate backtest(symbol, config), to: Backtest
end
