defmodule TrendFollowingWeb.PositionController do
  use TrendFollowingWeb, :controller

  alias TrendFollowing.Markets

  def show(conn, %{"hk_stock_symbol" => symbol} = params) do
    stock = Markets.get_stock!(symbol)

    dayk = 
      case Map.get(params, "date") do
        nil -> stock.dayk
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

    position = TrendFollowingKernel.position(system, stock, dayk, config)
    
    conn
    |> assign(:title, stock.cname <> "头寸方案")
    |> assign(:stock, stock)
    |> assign(:dayk, dayk)
    |> assign(:config, config)
    |> assign(:history, history)
    |> assign(:position, position)
    |> render(:show)
  end

end
