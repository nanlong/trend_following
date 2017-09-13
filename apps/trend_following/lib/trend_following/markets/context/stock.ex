defmodule TrendFollowing.Markets.Context.Stock do
  import Ecto.Query, warn: false
  alias TrendFollowing.Repo
  alias TrendFollowing.Markets.Stock

  @cn_markets ~w(SH SZ)
  @hk_markets ~w(HK)
  @us_markets ~w(NASDAQ NYSE AMEX)

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
  def get!(symbol), do: Repo.get_by!(Stock, symbol: symbol) |> Repo.preload(:dayk)

  def paginate(:cn, params), do: query_all_with_market(@cn_markets, params) |> query_paginate(params)
  def paginate(:cn_bull, params), do: query_bull_with_market(@cn_markets, params) |> query_paginate(params)
  def paginate(:cn_bear, params), do: query_bear_with_market(@cn_markets, params) |> query_paginate(params)
  def paginate(:cn_blacklist, params), do: query_blacklist_with_market(@cn_markets, params) |> query_paginate(params)
  def paginate(:cn_star, params), do: query_star_with_market(@cn_markets, params) |> query_paginate(params)
  def paginate(:hk, params), do: query_all_with_market(@hk_markets, params) |> query_paginate(params)
  def paginate(:hk_bull, params), do: query_bull_with_market(@hk_markets, params) |> query_paginate(params)
  def paginate(:hk_bear, params), do: query_bear_with_market(@hk_markets, params) |> query_paginate(params)
  def paginate(:hk_blacklist, params), do: query_blacklist_with_market(@hk_markets, params) |> query_paginate(params)
  def paginate(:hk_star, params), do: query_star_with_market(@hk_markets, params) |> query_paginate(params)
  def paginate(:us, params), do: query_all_with_market(@us_markets, params) |> query_paginate(params)
  def paginate(:us_bull, params), do: query_bull_with_market(@us_markets, params) |> query_paginate(params)
  def paginate(:us_bear, params), do: query_bear_with_market(@us_markets, params) |> query_paginate(params)
  def paginate(:us_blacklist, params), do: query_blacklist_with_market(@us_markets, params) |> query_paginate(params)
  def paginate(:us_star, params), do: query_star_with_market(@us_markets, params) |> query_paginate(params)

  defp query_all_with_market(market, params) do
    Stock
    |> query_with_market(market)
    |> query_filter(params)
    |> query_load_dayk()
    |> query_exclude_blacklist(Map.get(params, "user_id"))
    |> query_order_by()
  end

  defp query_bull_with_market(market, params) do
    Stock
    |> query_with_market(market)
    |> query_filter(params)
    |> query_load_dayk()
    |> query_exclude_blacklist(Map.get(params, "user_id"))
    |> query_bull()
    |> query_order_by()
  end

  defp query_bear_with_market(market, params) do
    Stock
    |> query_with_market(market)
    |> query_filter(params)
    |> query_load_dayk()
    |> query_exclude_blacklist(Map.get(params, "user_id"))
    |> query_bear()
    |> query_order_by()
  end

  defp query_blacklist_with_market(market, params) do
    Stock
    |> query_with_market(market)
    |> query_filter(params)
    |> query_load_dayk()
    |> query_include_blacklist(Map.get(params, "user_id"))
    |> query_order_by()
  end

  defp query_star_with_market(market, params) do
    Stock
    |> query_with_market(market)
    |> query_filter(params)
    |> query_load_dayk()
    |> query_include_star(Map.get(params, "user_id"))
    |> query_order_by()
  end

  defp query_with_market(query, market) do
    where(query, [stock], stock.market in ^market)
  end

  defp query_filter(query, params) do
    with {:ok, q} <- Map.fetch(params, "q"), q <- "%#{q}%" do
      where(query, [stock], ilike(stock.symbol, ^q) or ilike(stock.name, ^q) or ilike(stock.cname, ^q))
    else
      _ -> query
    end
  end

  defp query_bull(query) do
    join(query, :inner, [stock], dayk in assoc(stock, :dayk), dayk.ma50 > dayk.ma300 and dayk.atr > 0.1)
  end

  defp query_bear(query) do
    join(query, :inner, [stock], dayk in assoc(stock, :dayk), dayk.ma50 < dayk.ma300 and dayk.atr > 0.1)
  end

  defp query_exclude_blacklist(query, user_id) when is_nil(user_id), do: query
  defp query_exclude_blacklist(query, user_id) do
    where(query, [stock], fragment("? NOT IN (SELECT symbol FROM stock_blacklist where user_id = ?)", stock.symbol, type(^user_id, Ecto.UUID)))
  end

  defp query_include_blacklist(query, user_id) when is_nil(user_id), do: query
  defp query_include_blacklist(query, user_id) do
    join(query, :inner, [stock], black in StockBlacklist, black.user_id == ^user_id and black.symbol == stock.symbol)
  end

  defp query_include_star(query, user_id) when is_nil(user_id), do: query
  defp query_include_star(query, user_id) do
    join(query, :inner, [stock], star in Stocktar, star.user_id == ^user_id and star.symbol == stock.symbol)
  end

  defp query_load_dayk(query) do
    query
    |> where([stock], not is_nil(stock.dayk_id))
    |> preload([], [:dayk])
  end

  defp query_order_by(query) do
    order_by(query, [stock], desc: fragment("to_number(market_cap,'9999999999999.99')"))
  end

  defp query_paginate(query, params) do
    Repo.paginate(query, params)
  end
end