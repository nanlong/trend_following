defmodule TrendFollowing.Markets do

  # stock
  alias TrendFollowing.Markets.Context.Stock

  defdelegate create_stock(attrs), to: Stock, as: :create
  defdelegate update_stock(stock, attrs), to: Stock, as: :update
  defdelegate get_stock(symbol), to: Stock, as: :get
  defdelegate get_stock!(symbol), to: Stock, as: :get!
  defdelegate stock_paginate(market, params), to: Stock, as: :paginate

  # future
  alias TrendFollowing.Markets.Context.Future

  defdelegate create_future(attrs), to: Future, as: :create
  defdelegate update_future(future, attrs), to: Future, as: :update
  defdelegate get_future(symbol), to: Future, as: :get
  defdelegate list_future(market), to: Future, as: :list
  
  # stock dayk
  alias TrendFollowing.Markets.Context.Dayk

  defdelegate create_dayk(attrs), to: Dayk, as: :create
  defdelegate update_dayk(stock_dayk, attrs), to: Dayk, as: :update
  defdelegate get_dayk!(symbok, date), to: Dayk, as: :get!
  defdelegate list_dayk(symbol), to: Dayk, as: :list
  defdelegate list_dayk(symbol, limit), to: Dayk, as: :list

  def trend(dayk), do: if dayk.ma50 > dayk.ma300, do: "bull", else: "bear"
end
