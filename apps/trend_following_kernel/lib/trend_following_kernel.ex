defmodule TrendFollowingKernel do
  alias TrendFollowingKernel.Position

  defdelegate position(system, trade, dayk, config), to: Position
end
