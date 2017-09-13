defmodule TrendFollowingDataTest.HKStockTest do
  use ExUnit.Case
  alias TrendFollowingData.Sina.HKStock
  
  test "list" do
    assert %{status_code: 200, body: [stock | _]} = HKStock.get("list", page: 1)
    assert is_map(stock)
    assert Map.has_key?(stock, "symbol")
    assert Map.has_key?(stock, "engname")
    assert Map.has_key?(stock, "name")
  end

  test "dayk" do
    assert %{status_code: 200, body: [dayk | _]} = HKStock.get("dayk", symbol: "00700")
    assert is_map(dayk)
    assert Map.has_key?(dayk, "date")
    assert Map.has_key?(dayk, "open")
    assert Map.has_key?(dayk, "close")
    assert Map.has_key?(dayk, "high")
    assert Map.has_key?(dayk, "low")
    assert Map.has_key?(dayk, "volume")
  end

  test "detail" do
    assert %{status_code: 200, body: data} = HKStock.get("detail", symbol: "00700")
    assert is_map(data)
    assert Map.has_key?(data, "symbol")
    assert Map.has_key?(data, "name")
    assert Map.has_key?(data, "cname")
    assert Map.has_key?(data, "lot_size")
    assert Map.has_key?(data, "price")
    assert Map.has_key?(data, "diff")
    assert Map.has_key?(data, "chg")
    assert Map.has_key?(data, "pre_close")
    assert Map.has_key?(data, "open")
    assert Map.has_key?(data, "amount")
    assert Map.has_key?(data, "volume")
    assert Map.has_key?(data, "high")
    assert Map.has_key?(data, "low")
    assert Map.has_key?(data, "year_high")
    assert Map.has_key?(data, "year_low")
    assert Map.has_key?(data, "amplitude")
    assert Map.has_key?(data, "pe")
    assert Map.has_key?(data, "total_capital")
    assert Map.has_key?(data, "hk_capital")
    assert Map.has_key?(data, "hk_market_cap")
    assert Map.has_key?(data, "dividend_yield")
    assert Map.has_key?(data, "datetime")
  end
end