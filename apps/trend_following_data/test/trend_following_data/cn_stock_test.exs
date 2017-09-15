defmodule TrendFollowingDataTest.CNStockTest do
  use ExUnit.Case
  alias TrendFollowingData.Sina.CNStock
  
  test "list" do
    assert %{status_code: 200, body: data} = CNStock.get("list", page: 1)
    assert is_map(data)
    assert Map.has_key?(data, "result")
    data = Map.get(data, "result")
    assert Map.has_key?(data, "data")
    data = Map.get(data, "data")
    assert Map.has_key?(data, "data")
    [dayk | _] = Map.get(data, "data")
    assert is_map(dayk)
    assert Map.has_key?(dayk, "ext")
    ext = Map.get(dayk, "ext")
    assert is_map(ext)
    assert Map.has_key?(ext, "symbol")
    assert Map.has_key?(ext, "name")
  end

  test "dayk" do
    assert %{status_code: 200, body: [dayk | _]} = CNStock.get("dayk", symbol: "sh600036")
    assert is_map(dayk)
    assert Map.has_key?(dayk, "day")
    assert Map.has_key?(dayk, "open")
    assert Map.has_key?(dayk, "close")
    assert Map.has_key?(dayk, "high")
    assert Map.has_key?(dayk, "low")
    assert Map.has_key?(dayk, "volume")
  end

  test "mink" do
    assert %{status_code: 200, body: [mink | _]} = CNStock.get("mink", symbol: "sh600036")
    assert is_map(mink)
    assert Map.has_key?(mink, "day")
    assert Map.has_key?(mink, "open")
    assert Map.has_key?(mink, "close")
    assert Map.has_key?(mink, "high")
    assert Map.has_key?(mink, "low")
    assert Map.has_key?(mink, "volume")
  end

  test "detail" do
    assert %{status_code: 200, body: data} = CNStock.get("detail", symbol: "sh600036")
    assert is_map(data)
    assert Map.has_key?(data, "symbol")
    assert Map.has_key?(data, "name")
    assert Map.has_key?(data, "price")
    assert Map.has_key?(data, "open")
    assert Map.has_key?(data, "high")
    assert Map.has_key?(data, "low")
    assert Map.has_key?(data, "pre_close")
    assert Map.has_key?(data, "volume")
    assert Map.has_key?(data, "amount")
    assert Map.has_key?(data, "market_cap")
    assert Map.has_key?(data, "cur_market_cap")
    assert Map.has_key?(data, "turnover")
    assert Map.has_key?(data, "pb")
    assert Map.has_key?(data, "pe")
    assert Map.has_key?(data, "diff")
    assert Map.has_key?(data, "chg")
    assert Map.has_key?(data, "amplitude")
    assert Map.has_key?(data, "datetime")
  end
end