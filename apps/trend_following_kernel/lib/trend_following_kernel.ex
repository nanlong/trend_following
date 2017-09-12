defmodule TrendFollowingKernel do
  @moduledoc """
  system: [:system1 | :system2]
  """
  alias TrendFollowingKernel.Position
  alias TrendFollowingKernel.Backtest

  defdelegate position(system, trade, dayk, config), to: Position
  defdelegate backtest(system, symbol, config), to: Backtest
end
