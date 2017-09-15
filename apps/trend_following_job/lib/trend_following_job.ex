defmodule TrendFollowingJob do
  @moduledoc """
  沪深
  TrendFollowingJob.load_stock("cn")
  港股
  TrendFollowingJob.load_stock("hk")
  美股
  TrendFollowingJob.load_stock("us")
  国内期货
  TrendFollowingJob.load_future("i") 
  外盘期货
  TrendFollowingJob.load_future("g") 
  """
  
  def load_stock(market) do    
    Exq.enqueue(Exq, "default", TrendFollowingJob.Stock, [market, 1])
  end

  def load_future(market) do
    Exq.enqueue(Exq, "default", TrendFollowingJob.Future, [market])
  end
end
