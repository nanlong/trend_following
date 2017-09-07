defmodule TrendFollowingApiTest do
  use ExUnit.Case

  describe "sina cn stock" do
    alias TrendFollowingApi.Sina.CNStock

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
      assert Map.has_key?(data, "highest")
      assert Map.has_key?(data, "lowest")
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

  describe "sina us stock" do
    alias TrendFollowingApi.Sina.USStock

    test "list" do
      assert %{status_code: 200, body: data} = USStock.get("list", page: 1)
      assert is_map(data)
      assert Map.has_key?(data, "count")
      assert Map.has_key?(data, "data")
    end

    test "dayk" do
      assert %{status_code: 200, body: [dayk | _]} = USStock.get("dayk", symbol: "AAPL")
      assert is_map(dayk)
      assert Map.has_key?(dayk, "d")
      assert Map.has_key?(dayk, "o")
      assert Map.has_key?(dayk, "c")
      assert Map.has_key?(dayk, "h")
      assert Map.has_key?(dayk, "l")
      assert Map.has_key?(dayk, "v")
    end

    test "mink" do
      assert %{status_code: 200, body: [mink | _]} = USStock.get("mink", symbol: "AAPL", type: 5)
      assert is_map(mink)
      assert Map.has_key?(mink, "d")
      assert Map.has_key?(mink, "o")
      assert Map.has_key?(mink, "c")
      assert Map.has_key?(mink, "h")
      assert Map.has_key?(mink, "l")
      assert Map.has_key?(mink, "v")
    end

    test "detail" do
      assert %{status_code: 200, body: data} = USStock.get("detail", symbol: "AAPL")
      assert is_map(data)
      assert Map.has_key?(data, "symbol")
      assert Map.has_key?(data, "cname")
      assert Map.has_key?(data, "price")
      assert Map.has_key?(data, "diff")
      assert Map.has_key?(data, "datetime")
      assert Map.has_key?(data, "chg")
      assert Map.has_key?(data, "open")
      assert Map.has_key?(data, "high")
      assert Map.has_key?(data, "low")
      assert Map.has_key?(data, "year_high")
      assert Map.has_key?(data, "year_low")
      assert Map.has_key?(data, "volume")
      assert Map.has_key?(data, "volume_d10_avg")
      assert Map.has_key?(data, "market_cap")
      assert Map.has_key?(data, "eps")
      assert Map.has_key?(data, "pe")
      assert Map.has_key?(data, "beta")
      assert Map.has_key?(data, "dividend")
      assert Map.has_key?(data, "yield")
      assert Map.has_key?(data, "capital")
      assert Map.has_key?(data, "pre_close_datetime")
      assert Map.has_key?(data, "pre_close")
    end
  end
end
