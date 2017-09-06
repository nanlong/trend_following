defmodule TrendFollowing.MarketsTest do
  use TrendFollowing.DataCase

  alias TrendFollowing.Markets

  describe "stocks" do
    alias TrendFollowing.Markets.Stock

    @valid_attrs %{atr: 120.5, close: 120.5, date: ~D[2010-04-17], high: 120.5, low: 120.5, ma: %{}, open: 120.5, pre_close: 120.5, symbol: "some symbol", tr: 120.5, volume: 42}
    @update_attrs %{atr: 456.7, close: 456.7, date: ~D[2011-05-18], high: 456.7, low: 456.7, ma: %{}, open: 456.7, pre_close: 456.7, symbol: "some updated symbol", tr: 456.7, volume: 43}
    @invalid_attrs %{atr: nil, close: nil, date: nil, high: nil, low: nil, ma: nil, open: nil, pre_close: nil, symbol: nil, tr: nil, volume: nil}

    def stock_fixture(attrs \\ %{}) do
      {:ok, stock} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Markets.create_stock()

      stock
    end

    test "list_stocks/0 returns all stocks" do
      stock = stock_fixture()
      assert Markets.list_stocks() == [stock]
    end

    test "get_stock!/1 returns the stock with given id" do
      stock = stock_fixture()
      assert Markets.get_stock!(stock.id) == stock
    end

    test "create_stock/1 with valid data creates a stock" do
      assert {:ok, %Stock{} = stock} = Markets.create_stock(@valid_attrs)
      assert stock.atr == 120.5
      assert stock.close == 120.5
      assert stock.date == ~D[2010-04-17]
      assert stock.high == 120.5
      assert stock.low == 120.5
      assert stock.ma == %{}
      assert stock.open == 120.5
      assert stock.pre_close == 120.5
      assert stock.symbol == "some symbol"
      assert stock.tr == 120.5
      assert stock.volume == 42
    end

    test "create_stock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Markets.create_stock(@invalid_attrs)
    end

    test "update_stock/2 with valid data updates the stock" do
      stock = stock_fixture()
      assert {:ok, stock} = Markets.update_stock(stock, @update_attrs)
      assert %Stock{} = stock
      assert stock.atr == 456.7
      assert stock.close == 456.7
      assert stock.date == ~D[2011-05-18]
      assert stock.high == 456.7
      assert stock.low == 456.7
      assert stock.ma == %{}
      assert stock.open == 456.7
      assert stock.pre_close == 456.7
      assert stock.symbol == "some updated symbol"
      assert stock.tr == 456.7
      assert stock.volume == 43
    end

    test "update_stock/2 with invalid data returns error changeset" do
      stock = stock_fixture()
      assert {:error, %Ecto.Changeset{}} = Markets.update_stock(stock, @invalid_attrs)
      assert stock == Markets.get_stock!(stock.id)
    end

    test "delete_stock/1 deletes the stock" do
      stock = stock_fixture()
      assert {:ok, %Stock{}} = Markets.delete_stock(stock)
      assert_raise Ecto.NoResultsError, fn -> Markets.get_stock!(stock.id) end
    end

    test "change_stock/1 returns a stock changeset" do
      stock = stock_fixture()
      assert %Ecto.Changeset{} = Markets.change_stock(stock)
    end
  end
end
