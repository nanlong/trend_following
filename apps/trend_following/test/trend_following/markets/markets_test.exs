defmodule TrendFollowing.MarketsTest do
  use TrendFollowing.DataCase

  alias TrendFollowing.Markets

  describe "stock_dayk" do
    alias TrendFollowing.Markets.StockDayk

    @valid_attrs %{symbol: "AAPL", date: ~D[2017-08-25], open: 159.65, close: 159.86, high: 160.56, low: 159.27, volume: 25015017}
    @update_attrs %{ma5: 159.22, ma10: 159.39, ma20: 157.72, ma30: 155.47, ma50: 151.32, ma300: 127.42, high20: 162.51, high60: 162.51, low10: 155.11, low20: 148.13, tr: 1.29, atr: 2.65}
    @invalid_attrs %{symbol: nil, date: nil, open: nil, close: nil, high: nil, low: nil, volume: nil}

    def stock_dayk_fixture(attrs \\ %{}) do
      {:ok, stock_dayk} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Markets.create_stock_dayk()

      stock_dayk
    end

    test "list_stock_dayk/0 returns all stocks" do
      stock_dayk = stock_dayk_fixture()
      assert Markets.list_stock_dayk("AAPL") == [stock_dayk]
    end

    test "get_stock_dayk!/1 returns the stock_dayk with given symbol and date" do
      stock_dayk = stock_dayk_fixture()
      assert Markets.get_stock_dayk!(stock_dayk.symbol, stock_dayk.date) == stock_dayk
    end

    test "create_stock_dayk/1 with valid data creates a stock_dayk" do
      assert {:ok, %StockDayk{} = stock_dayk} = Markets.create_stock_dayk(@valid_attrs)
      assert stock_dayk.symbol == "AAPL"
      assert stock_dayk.date == ~D[2017-08-25]
      assert stock_dayk.open == 159.65
      assert stock_dayk.close == 159.86
      assert stock_dayk.high == 160.56
      assert stock_dayk.low == 159.27
      assert stock_dayk.volume == 25015017
    end

    test "create_stock_dayk/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Markets.create_stock_dayk(@invalid_attrs)
    end

    test "update_stock_dayk/2 with valid data updates the stock_dayk" do
      stock_dayk = stock_dayk_fixture()
      assert {:ok, %StockDayk{} = stock_dayk} = Markets.update_stock_dayk(stock_dayk, @update_attrs)
      assert stock_dayk.ma5 == 159.22
      assert stock_dayk.ma10 == 159.39
      assert stock_dayk.ma20 == 157.72
      assert stock_dayk.ma30 == 155.47
      assert stock_dayk.ma50 == 151.32
      assert stock_dayk.ma300 == 127.42
      assert stock_dayk.tr == 1.29
      assert stock_dayk.atr == 2.65
    end

    test "update_stock_dayk/2 with invalid data returns error changeset" do
      stock_dayk = stock_dayk_fixture()
      assert {:error, %Ecto.Changeset{}} = Markets.update_stock_dayk(stock_dayk, @invalid_attrs)
      assert stock_dayk == Markets.get_stock_dayk!(stock_dayk.symbol, stock_dayk.date)
    end
  end
end
