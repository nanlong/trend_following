defmodule TrendFollowingJob.Stock do
  @moduledoc """
    TrendFollowingJob.Stock.load(:cn, 1, fn(market, symbol) -> 
      TrendFollowingJob.StockDetail.load(market, symbol)
    end)

    TrendFollowingJob.Stock.load(:hk, 1, fn(market, symbol) -> 
      TrendFollowingJob.StockDetail.load(market, symbol)
    end)

    TrendFollowingJob.Stock.load(:us, 1)
  """
  alias TrendFollowing.Markets
  
  def load(market, page, fun \\ fn(_, _) -> nil end) do
    %{body: data} = stock_data(market, page)
    has_next = has_next?(market, data)
    data = data_handler(market, data)

    Enum.map(data, fn(attrs) -> 
      case Markets.get_stock(attrs.symbol) do
        nil -> Markets.create_stock(attrs)
        stock -> Markets.update_stock(stock, attrs)
      end

      fun.(market, attrs.symbol)
    end)

    %{has_next: has_next}
  end

  defp stock_data(:cn, page), do: TrendFollowingApi.Sina.CNStock.get("list", page: page)
  defp stock_data(:hk, page), do: TrendFollowingApi.Sina.HKStock.get("list", page: page)
  defp stock_data(:us, page), do: TrendFollowingApi.Sina.USStock.get("list", page: page)

  defp has_next?(:cn, data) do
    page_cur = get_in(data, ["result", "data", "pageCur"])
    page_num = get_in(data, ["result", "data", "pageNum"])
    page_cur + 1 <= page_num
  end
  defp has_next?(:hk, data), do: not is_nil(data)
  defp has_next?(:us, data), do: length(Map.get(data, "data")) > 0

  defp data_handler(:cn, data) do
    data = get_in(data, ["result", "data", "data"])
    
    Enum.map(data, fn(x) -> 
      %{
        market: Regex.named_captures(~r/(?<market>[sh|sz]+)/, Map.get(x, "symbol")) |> Map.get("market") |> String.upcase(),
        symbol: Map.get(x, "symbol"),
        name: get_in(x, ["ext", "name"]),
        cname: get_in(x, ["ext", "name"]),
        lot_size: 100,
      }  
    end)
  end
  defp data_handler(:hk, data) do
    Enum.map(data, fn(x) -> 
      %{
        market: "HK",
        symbol: Map.get(x, "symbol"),
        name: Map.get(x, "engname"),
        cname: Map.get(x, "name"),
        lot_size: 100,
      }
    end)
  end
  defp data_handler(:us, data) do
    data = Map.get(data, "data")

    Enum.map(data, fn(x) -> 
      %{
        market: Map.get(x, "market"),
        symbol: Map.get(x, "symbol"),
        name: Map.get(x, "name"),
        cname: Map.get(x, "cname"),
        category: Map.get(x, "category"),
        market_cap: Map.get(x, "mktcap"),
        pe: Map.get(x, "pe"),
        lot_size: 1,
      }
    end)
  end
end