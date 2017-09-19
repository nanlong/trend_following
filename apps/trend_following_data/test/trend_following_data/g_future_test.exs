defmodule TrendFollowingDataTest.GFutureTest do
  use ExUnit.Case
  alias TrendFollowingData.Sina.GFuture

  test "list" do
    assert %{status_code: 200, body: %{"result" => %{"data" => %{"global_good" => [data | _]}}}} = GFuture.get("list")
    assert is_map(data)
    assert Map.has_key?(data, "symbol")
  end

  test "dayk" do
    assert %{status_code: 200, body: [data | _]} = GFuture.get("dayk", symbol: "CL")
    assert is_map(data)
    assert Map.has_key?(data, "date")
    assert Map.has_key?(data, "open")
    assert Map.has_key?(data, "close")
    assert Map.has_key?(data, "high")
    assert Map.has_key?(data, "low")
    assert Map.has_key?(data, "volume")
  end

  test "detail" do
    assert %{status_code: 200, body: data} = GFuture.get("detail", symbol: "CL")
    assert is_map(data)
    assert Map.has_key?(data, "buy_positions")
    assert Map.has_key?(data, "buy_price")
    assert Map.has_key?(data, "chg")
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
  end
end