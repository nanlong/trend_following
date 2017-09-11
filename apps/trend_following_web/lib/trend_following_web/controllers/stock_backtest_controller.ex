defmodule TrendFollowingWeb.StockBacktestController do
  use TrendFollowingWeb, :controller

  alias TrendFollowing.Markets

  def show(conn, %{"symbol" => symbol}) do
    stock = Markets.get_stock!(symbol)

    config = %{
      account: 1000000, 
      atr_rate: 0.01, 
      atr_add: 0.5,
      stop_loss: 0.02,
      position_max: 4,
    }

    results = TrendFollowingKernel.Backtest.backtest(symbol, config)
    
    conn
    |> assign(:title, "回测")
    |> assign(:stock, stock)
    |> assign(:results, results)
    |> render(:show)
  end

end
