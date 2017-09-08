defmodule TrendFollowing.Markets do

  # stock
  alias TrendFollowing.Markets.Context.Stock

  defdelegate create_stock(attrs), to: Stock, as: :create
  defdelegate update_stock(stock, attrs), to: Stock, as: :update
  defdelegate get_stock!(symbol), to: Stock, as: :get!
  
  # stock dayk
  alias TrendFollowing.Markets.Context.Dayk

  defdelegate create_dayk(attrs), to: Dayk, as: :create
  defdelegate update_dayk(stock_dayk, attrs), to: Dayk, as: :update
  defdelegate get_dayk!(symbok, date), to: Dayk, as: :get!
  defdelegate list_dayk(symbol), to: Dayk, as: :list
end
