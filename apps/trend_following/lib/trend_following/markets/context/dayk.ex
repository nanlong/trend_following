defmodule TrendFollowing.Markets.Context.Dayk do
  import Ecto.Query, warn: false
  alias TrendFollowing.Repo
  alias TrendFollowing.Markets.Dayk

  def create(attrs) do
    %Dayk{}
    |> Dayk.changeset(attrs)
    |> Repo.insert()
  end

  def update(dayk, attrs) do
    dayk
    |> Dayk.changeset(attrs)
    |> Repo.update()
  end

  def get!(symbol, date) do
    Repo.get_by!(Dayk, symbol: symbol, date: date)
  end

  def list(symbol) do
    Dayk
    |> where([d], d.symbol == ^symbol)
    |> order_by([d], asc: d.date)
    |> Repo.all()
  end

  def list(symbol, limit) do
    Dayk
    |> where([d], d.symbol == ^symbol)
    |> order_by([d], desc: d.date)
    |> limit(^limit)
    |> Repo.all()
    |> Enum.reverse()
  end
end