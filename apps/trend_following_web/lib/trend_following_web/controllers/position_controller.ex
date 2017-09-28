defmodule TrendFollowingWeb.PositionController do
  use TrendFollowingWeb, :controller

  alias TrendFollowing.Markets

  def show(conn, params) do
    current_user = current_user(conn)

    {market, symbol, product} = 
      cond do
        Map.has_key?(params, "cn_stock_symbol") -> 
          symbol = Map.get(params, "cn_stock_symbol")
          {"cn_stock", symbol, Markets.get_stock!(symbol)}
        Map.has_key?(params, "hk_stock_symbol") -> 
          symbol = Map.get(params, "hk_stock_symbol")
          {"hk_stock", symbol, Markets.get_stock!(symbol)}
        Map.has_key?(params, "us_stock_symbol") -> 
          symbol = Map.get(params, "us_stock_symbol")
          {"us_stock", symbol, Markets.get_stock!(symbol)}
        Map.has_key?(params, "i_future_symbol") -> 
          symbol = Map.get(params, "i_future_symbol")
          {"i_future", symbol, Markets.get_future(symbol)}
        Map.has_key?(params, "g_future_symbol") -> 
          symbol = Map.get(params, "g_future_symbol")
          {"g_future", symbol, Markets.get_future(symbol)}
      end

    dayk = 
      case Map.get(params, "date") do
        nil -> product.dayk
        date -> Markets.get_dayk!(symbol, date)
      end

    system =
      case Map.get(params, "system") do
        nil -> :system1
        system -> String.to_atom(system)
      end

    config = 
      case Markets.get_trend_config(current_user.id, market) do
        nil -> Markets.default_trend_config(market)
        trend_config -> trend_config
      end

    history = Markets.list_dayk(symbol, 60)

    position = TrendFollowingKernel.position(system, product, dayk, convert_trend_config(config))
    
    conn
    |> assign(:title, product.name <> "头寸方案")
    |> assign(:market, market)
    |> assign(:product, product)
    |> assign(:dayk, dayk)
    |> assign(:config, config)
    |> assign(:history, history)
    |> assign(:position, position)
    |> render(:show)
  end

end
