defmodule TrendFollowing.Markets.Context.Stock do
  import Ecto.Query, warn: false
  alias TrendFollowing.Repo
  alias TrendFollowing.Markets.Stock

  def create(attrs) do
    %Stock{}
    |> Stock.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Stock{} = stock, attrs) do
    stock
    |> Stock.changeset(attrs)
    |> Repo.update()
  end

  def get(symbol), do: Repo.get_by(Stock, symbol: symbol)
  def get!(symbol), do: Repo.get_by!(Stock, symbol: symbol)
end