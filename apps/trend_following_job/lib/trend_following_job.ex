defmodule TrendFollowingJob do
  
  def load_stock(market) do    
    Exq.enqueue(Exq, "default", TrendFollowingJob.Stock, [market, 1])
  end
end
