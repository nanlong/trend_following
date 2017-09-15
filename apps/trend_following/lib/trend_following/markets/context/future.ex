defmodule TrendFollowing.Markets.Context.Future do
  import Ecto.Query, warn: false
  alias TrendFollowing.Repo
  alias TrendFollowing.Markets.Future

  def get(symbol), do: Repo.get_by(Future, symbol: symbol)

  def create(attrs) do
    %Future{}
    |> Future.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Future{} = future, attrs) do
    future
    |> Future.changeset(attrs)
    |> Repo.update()
  end
end