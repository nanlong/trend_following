defmodule TrendFollowingKernelTest do
  use ExUnit.Case
  doctest TrendFollowingKernel

  @dayk %{
    symbol: "AAPL", 
    date: ~D[2017-08-25], 
    open: 159.65, 
    close: 159.86, 
    high: 160.56, 
    low: 159.27, 
    volume: 25015017,
    ma5: 159.22, 
    ma10: 159.39, 
    ma20: 157.72, 
    ma30: 155.47, 
    ma50: 151.32, 
    ma300: 127.42, 
    high10: 162.5, 
    high20: 162.51, 
    high60: 168.51, 
    low10: 155.11, 
    low20: 148.13, 
    low60: 142.2, 
    tr: 1.29, 
    atr: 8.65
  }

  @trade %{
    lot_size: 1
  }

  @config %{
    account: 1000000, 
    atr_rate: 0.01, 
    atr_add: 0.5,
    stop_loss: 0.02,
    position_max: 4,
  }

  @tag trend_following_kernel: true
  test "positions" do
    assert %{
      account_min: 865, 
      atr: 8.65, 
      break_price: 162.51, 
      close_price: 155.11,
      date: ~D[2017-08-25],
      positions: [
        %{avg_price: 162.51, buy_price: 162.51, stop_price: 145.21},
        %{avg_price: 164.6725, buy_price: 166.835, stop_price: 156.0225},
        %{avg_price: 166.835, buy_price: 171.16, stop_price: 161.0683},
        %{avg_price: 168.9975, buy_price: 175.485, stop_price: 164.6725}
      ], 
      symbol: "AAPL", 
      unit: 1156
    } = TrendFollowingKernel.position(:system1, @trade, @dayk, @config) 
    
    assert %{
      account_min: 865, 
      atr: 8.65, 
      break_price: 168.51, 
      close_price: 148.13,
      date: ~D[2017-08-25],
      positions: [
        %{avg_price: 168.51, buy_price: 168.51, stop_price: 151.21},
        %{avg_price: 170.6725, buy_price: 172.835, stop_price: 162.0225},
        %{avg_price: 172.835, buy_price: 177.16, stop_price: 167.0683},
        %{avg_price: 174.9975, buy_price: 181.485, stop_price: 170.6725}
      ], 
      symbol: "AAPL", 
      unit: 1156
    } = TrendFollowingKernel.position(:system2, @trade, @dayk, @config)
  end
end
