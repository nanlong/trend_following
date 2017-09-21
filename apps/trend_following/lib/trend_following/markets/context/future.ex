defmodule TrendFollowing.Markets.Context.Future do
  import Ecto.Query, warn: false
  alias TrendFollowing.Repo
  alias TrendFollowing.Markets.Future

  @i_markets ~w(CZCE DCE SHFE)
  @g_markets ~w(GLOBAL)

  def get(symbol), do: Repo.get_by(Future, symbol: symbol) |> Repo.preload(:dayk)

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
    |> query_load_dayk()
    |> Repo.all()
  end
  def list(:i_bull) do
    Future
    |> where([f], f.market in @i_markets)
    |> query_load_dayk()
    |> query_bull()
    |> query_order_by()
    |> Repo.all()
  end
  def list(:i_bear) do
    Future
    |> where([f], f.market in @i_markets)
    |> query_load_dayk()
    |> query_bear()
    |> query_order_by()
    |> Repo.all()
  end
  def list(:g) do
    Future
    |> where([f], f.market in @g_markets)
    |> query_load_dayk()
    |> Repo.all()
  end
  def list(:g_bull) do
    Future
    |> where([f], f.market in @g_markets)
    |> query_load_dayk()
    |> query_bull()
    |> query_order_by()
    |> Repo.all()
  end
  def list(:g_bear) do
    Future
    |> where([f], f.market in @g_markets)
    |> query_load_dayk()
    |> query_bear()
    |> query_order_by()
    |> Repo.all()
  end

  defp query_load_dayk(query) do
    query
    |> where([future], not is_nil(future.dayk_id))
    |> preload([], [:dayk])
  end

  defp query_bull(query) do
    join(query, :inner, [future], dayk in assoc(future, :dayk), dayk.ma50 > dayk.ma300)
  end

  defp query_bear(query) do
    join(query, :inner, [future], dayk in assoc(future, :dayk), dayk.ma50 < dayk.ma300)
  end

  defp query_order_by(query) do
    order_by(query, [future], desc: fragment("to_number(volume,'9999999999999.99')"))
  end
end