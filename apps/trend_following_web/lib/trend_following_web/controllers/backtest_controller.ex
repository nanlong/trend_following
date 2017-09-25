defmodule TrendFollowingWeb.BacktestController do
  use TrendFollowingWeb, :controller

  alias TrendFollowing.Markets

  def show(conn, params) do
    current_user = current_user(conn)

    {market, _symbol, product} = 
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

    backtest = TrendFollowingKernel.backtest(system, product, convert_trend_config(config))
    
    conn
    |> assign(:title, product.name <> "回测情况")
    |> assign(:product, product)
    |> assign(:backtest, backtest)
    |> render(:show)
  end

end
