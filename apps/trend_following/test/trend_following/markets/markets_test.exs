defmodule TrendFollowing.MarketsTest do
  use TrendFollowing.DataCase
  alias TrendFollowing.Markets

  describe "stock" do
    alias TrendFollowing.Markets.Stock

    @valid_attrs %{market: "NASDAQ", symbol: "AAPL", name: "Apple Inc.", cname: "苹果公司", lot_size: 1}
    @update_attrs %{category: "计算机", market_cap: "825713683741", pe: "19.19087660", trading_unit: "美元", price_quote: "股", minimum_price_change: "0.01美元"}
    @invalid_attrs %{market: nil, symbol: nil, name: nil, cname: nil, lot_size: nil}

    def stock_fixture(attrs \\ %{}) do
      {:ok, stock} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Markets.create_stock()

      stock
    end

    @tag trend_following_markets: true
    test "create" do
      assert {:ok, %Stock{} = stock} = Markets.create_stock(@valid_attrs)
      assert stock.market == "NASDAQ"
      assert stock.symbol == "AAPL"
      assert stock.name == "Apple Inc."
      assert stock.cname == "苹果公司"
      assert stock.lot_size == 1
    end

    @tag trend_following_markets: true
    test "update" do
      stock = stock_fixture()
      assert {:ok, %Stock{} = stock} = Markets.update_stock(stock, @update_attrs)
      assert stock.category == "计算机"
      assert stock.market_cap == "825713683741"
      assert stock.pe == "19.19087660"
      assert stock.trading_unit == "美元"
      assert stock.price_quote == "股"
      assert stock.minimum_price_change == "0.01美元"
    end

    @tag trend_following_markets: true
    test "get" do
      stock = stock_fixture()
      assert Markets.get_stock(stock.symbol) == stock
    end

    @tag trend_following_markets: true
    test "create error" do
      assert {:error, %Ecto.Changeset{}} = Markets.create_stock(@invalid_attrs)
    end
  end

  describe "future" do
    alias TrendFollowing.Markets.Future

    @valid_attrs %{symbol: "CL", name: "NYMEX原油", market: "GLOBAL"}
    @update_attrs %{lot_size: 1000, trading_unit: "美元", price_quote: "桶", minimum_price_change: "0.01美元"}
    @invalid_attrs %{symbol: nil, name: nil, market: nil}

    def future_fixture(attrs \\ %{}) do
      {:ok, future} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Markets.create_future()

      future
    end

    @tag trend_following_markets: true
    test "create with valid_attrs" do
      assert {:ok, %Future{} = future} = Markets.create_future(@valid_attrs)
      assert future.symbol == "CL"
      assert future.name == "NYMEX原油"
      assert future.market == "GLOBAL"
    end

    @tag trend_following_markets: true
    test "create with invalid_attrs" do
      assert {:error, %Ecto.Changeset{}} = Markets.create_future(@invalid_attrs)
    end

    @tag trend_following_markets: true
    test "get" do
      future = future_fixture()
      assert Markets.get_future(future.symbol) == future
    end

    @tag trend_following_markets: true
    test "update" do
      future = future_fixture()
      assert {:ok, %Future{} = future} = Markets.update_future(future, @update_attrs)
      assert future.lot_size == 1000
      assert future.trading_unit == "美元"
      assert future.price_quote == "桶"
      assert future.minimum_price_change == "0.01美元"
    end

    @tag trend_following_markets: true
    test "list" do
      future = future_fixture()
      assert Markets.list_future(:g) == [future]
    end
  end

  describe "dayk" do
    alias TrendFollowing.Markets.Dayk

    @valid_attrs %{symbol: "AAPL", date: ~D[2017-08-25], open: 159.65, close: 159.86, high: 160.56, low: 159.27, volume: "25015017"}
    @update_attrs %{ma5: 159.22, ma10: 159.39, ma20: 157.72, ma30: 155.47, ma50: 151.32, ma300: 127.42, high10: 162.5, high20: 162.51, high60: 162.51, low10: 155.11, low20: 148.13, low60: 142.2, tr: 1.29, atr: 2.65}
    @invalid_attrs %{symbol: nil, date: nil, open: nil, close: nil, high: nil, low: nil, volume: nil}

    def dayk_fixture(attrs \\ %{}) do
      {:ok, dayk} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Markets.create_dayk()

      dayk
    end

    @tag trend_following_markets: true
    test "list_dayk/0 returns all stocks" do
      dayk = dayk_fixture()
      assert Markets.list_dayk("AAPL") == [dayk]
    end

    @tag trend_following_markets: true
    test "get_dayk!/1 returns the dayk with given symbol and date" do
      dayk = dayk_fixture()
      assert Markets.get_dayk!(dayk.symbol, dayk.date) == dayk
    end

    @tag trend_following_markets: true
    test "create_dayk/1 with valid data creates a dayk" do
      assert {:ok, %Dayk{} = dayk} = Markets.create_dayk(@valid_attrs)
      assert dayk.symbol == "AAPL"
      assert dayk.date == ~D[2017-08-25]
      assert dayk.open == 159.65
      assert dayk.close == 159.86
      assert dayk.high == 160.56
      assert dayk.low == 159.27
      assert dayk.volume == "25015017"
    end

    @tag trend_following_markets: true
    test "create_dayk/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Markets.create_dayk(@invalid_attrs)
    end

    @tag trend_following_markets: true
    test "update_dayk/2 with valid data updates the dayk" do
      dayk = dayk_fixture()
      assert {:ok, %Dayk{} = dayk} = Markets.update_dayk(dayk, @update_attrs)
      assert dayk.ma5 == 159.22
      assert dayk.ma10 == 159.39
      assert dayk.ma20 == 157.72
      assert dayk.ma30 == 155.47
      assert dayk.ma50 == 151.32
      assert dayk.ma300 == 127.42
      assert dayk.tr == 1.29
      assert dayk.atr == 2.65
    end

    @tag trend_following_markets: true
    test "update_dayk/2 with invalid data returns error changeset" do
      dayk = dayk_fixture()
      assert {:error, %Ecto.Changeset{}} = Markets.update_dayk(dayk, @invalid_attrs)
      assert dayk == Markets.get_dayk!(dayk.symbol, dayk.date)
    end
  end
end
