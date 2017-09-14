defmodule TrendFollowingJob do
  @moduledoc """
  TrendFollowingJob.load_stock("cn")
  TrendFollowingJob.load_stock("hk")
  TrendFollowingJob.load_stock("us")
  """
  
  def load_stock(market) do    
    Exq.enqueue(Exq, "default", TrendFollowingJob.Stock, [market, 1])
  end
end
