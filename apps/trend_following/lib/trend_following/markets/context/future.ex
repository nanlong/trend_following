defmodule TrendFollowing.Markets.Context.Future do
  import Ecto.Query, warn: false
  alias TrendFollowing.Repo
  alias TrendFollowing.Markets.Future

  @i_markets ~w(CZCE DCE SHFE)
  @g_markets ~w(GLOBAL)

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

  def list(:i) do
    Future
    |> where([f], f.market in @i_markets)
    |> Repo.all()
  end
  def list(:g) do
    Future
    |> where([f], f.market in @g_markets)
    |> Repo.all()
  end
end