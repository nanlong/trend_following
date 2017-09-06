defmodule TrendFollowing.Markets do
  
  # stock dayk
  alias TrendFollowing.Markets.Context.StockDayk

  defdelegate create_stock_dayk(attrs), to: StockDayk, as: :create
  defdelegate update_stock_dayk(stock_dayk, attrs), to: StockDayk, as: :update
  defdelegate get_stock_dayk!(symbok, date), to: StockDayk, as: :get!
  defdelegate list_stock_dayk(symbol), to: StockDayk, as: :list
end
