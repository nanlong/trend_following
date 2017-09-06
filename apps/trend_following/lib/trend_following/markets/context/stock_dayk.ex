defmodule TrendFollowing.Markets.Context.StockDayk do
  import Ecto.Query, warn: false
  alias TrendFollowing.Repo
  alias TrendFollowing.Markets.StockDayk

  def create(attrs) do
    %StockDayk{}
    |> StockDayk.changeset(attrs)
    |> Repo.insert()
  end

  def update(stock_dayk, attrs) do
    stock_dayk
    |> StockDayk.changeset(attrs)
    |> Repo.update()
  end

  def get!(symbol, date) do
    Repo.get_by!(StockDayk, symbol: symbol, date: date)
  end

  def list(symbol) do
    StockDayk
    |> where([d], d.symbol == ^symbol)
    |> order_by([d], asc: d.date)
    |> Repo.all()
  end
end