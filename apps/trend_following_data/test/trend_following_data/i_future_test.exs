defmodule TrendFollowingDataTest.IFutureTest do
  use ExUnit.Case
  alias TrendFollowingData.Sina.IFuture

  test "list" do
    assert %{status_code: 200, body: data} = IFuture.get("list")
    assert is_map(data)
    assert Map.has_key?(data, "result")
    data = Map.get(data, "result")
    assert is_map(data)
    assert Map.has_key?(data, "data")
    data = Map.get(data, "data")
    assert is_map(data)
    assert Map.has_key?(data, "czce")
    assert Map.has_key?(data, "dce")
    assert Map.has_key?(data, "shfe")
    assert %{"czce" => [data | _]} = data
    assert is_map(data)
    assert Map.has_key?(data, "market")
    assert Map.has_key?(data, "symbol")
    assert Map.has_key?(data, "name")
    assert Map.has_key?(data, "contract")
  end

  test "dayk" do
    assert %{status_code: 200, body: [data | _]} = IFuture.get("dayk", symbol: "TA0")
    assert is_map(data)
    assert Map.has_key?(data, "d")
    assert Map.has_key?(data, "o")
    assert Map.has_key?(data, "c")
    assert Map.has_key?(data, "h")
    assert Map.has_key?(data, "l")
    assert Map.has_key?(data, "v")
  end

  test "detail" do
    assert %{status_code: 200, body: data} = IFuture.get("detail", symbol: "TA0")
    assert is_map(data)
    assert Map.has_key?(data, "buy_positions")
    assert Map.has_key?(data, "buy_price")
    assert Map.has_key?(data, "chg")
    assert Map.has_key?(data, "close")
    assert Map.has_key?(data, "datetime")
    assert Map.has_key?(data, "diff")
    assert Map.has_key?(data, "high")
    assert Map.has_key?(data, "lot_size")
    assert Map.has_key?(data, "low")
    assert Map.has_key?(data, "minimum_price_change")
    assert Map.has_key?(data, "name")
    assert Map.has_key?(data, "open")
    assert Map.has_key?(data, "open_positions")
    assert Map.has_key?(data, "pre_close")
    assert Map.has_key?(data, "price")
    assert Map.has_key?(data, "price_quote")
    assert Map.has_key?(data, "sell_positions")
    assert Map.has_key?(data, "sell_price")
    assert Map.has_key?(data, "symbol")
    assert Map.has_key?(data, "trading_unit")
    assert Map.has_key?(data, "volume")
  end
end