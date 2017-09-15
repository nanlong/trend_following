defmodule TrendFollowingWeb.PositionController do
  use TrendFollowingWeb, :controller

  alias TrendFollowing.Markets

  def show(conn, params) do
    {symbol, product} = 
      cond do
        Map.has_key?(params, "cn_stock_symbol") -> 
          symbol = Map.get(params, "cn_stock_symbol")
          {symbol, Markets.get_stock!(symbol)}
        Map.has_key?(params, "hk_stock_symbol") -> 
          symbol = Map.get(params, "hk_stock_symbol")
          {symbol, Markets.get_stock!(symbol)}
        Map.has_key?(params, "us_stock_symbol") -> 
          symbol = Map.get(params, "us_stock_symbol")
          {symbol, Markets.get_stock!(symbol)}
        Map.has_key?(params, "i_future_symbol") -> 
          symbol = Map.get(params, "i_future_symbol")
          {symbol, Markets.get_future(symbol)}
        Map.has_key?(params, "g_future_symbol") -> 
          symbol = Map.get(params, "g_future_symbol")
          {symbol, Markets.get_future(symbol)}
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

    config = %{
      account: 1000000, 
      atr_rate: 0.01, 
      atr_add: 0.5,
      stop_loss: 0.02,
      position_max: 4,
    }

    history = Markets.list_dayk(symbol, 60)

    position = TrendFollowingKernel.position(system, product, dayk, config)
    
    conn
    |> assign(:title, product.name <> "头寸方案")
    |> assign(:product, product)
    |> assign(:dayk, dayk)
    |> assign(:config, config)
    |> assign(:history, history)
    |> assign(:position, position)
    |> render(:show)
  end

end
