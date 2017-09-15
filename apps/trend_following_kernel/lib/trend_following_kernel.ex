defmodule TrendFollowingKernel do
  @moduledoc """
  TrendFollowingKernel.backtest(:system1, "00700", config)
  system: [:system1 | :system2]
  """
  alias TrendFollowingKernel.Position
  alias TrendFollowingKernel.Backtest

  defdelegate position(system, product, dayk, config), to: Position
  defdelegate backtest(system, symbol, config), to: Backtest
end
