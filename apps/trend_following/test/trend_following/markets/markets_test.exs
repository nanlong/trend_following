defmodule TrendFollowing.MarketsTest do
  use TrendFollowing.DataCase

  alias TrendFollowing.Markets

  describe "dayk" do
    alias TrendFollowing.Markets.Dayk

    @valid_attrs %{symbol: "AAPL", date: ~D[2017-08-25], open: 159.65, close: 159.86, high: 160.56, low: 159.27, volume: 25015017}
    @update_attrs %{ma5: 159.22, ma10: 159.39, ma20: 157.72, ma30: 155.47, ma50: 151.32, ma300: 127.42, high10: 162.5, high20: 162.51, high60: 162.51, low10: 155.11, low20: 148.13, low60: 142.2, tr: 1.29, atr: 2.65}
    @invalid_attrs %{symbol: nil, date: nil, open: nil, close: nil, high: nil, low: nil, volume: nil}

    def dayk_fixture(attrs \\ %{}) do
      {:ok, dayk} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Markets.create_dayk()

      dayk
    end

    test "list_dayk/0 returns all stocks" do
      dayk = dayk_fixture()
      assert Markets.list_dayk("AAPL") == [dayk]
    end

    test "get_dayk!/1 returns the dayk with given symbol and date" do
      dayk = dayk_fixture()
      assert Markets.get_dayk!(dayk.symbol, dayk.date) == dayk
    end

    test "create_dayk/1 with valid data creates a dayk" do
      assert {:ok, %Dayk{} = dayk} = Markets.create_dayk(@valid_attrs)
      assert dayk.symbol == "AAPL"
      assert dayk.date == ~D[2017-08-25]
      assert dayk.open == 159.65
      assert dayk.close == 159.86
      assert dayk.high == 160.56
      assert dayk.low == 159.27
      assert dayk.volume == 25015017
    end

    test "create_dayk/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Markets.create_dayk(@invalid_attrs)
    end

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

    test "update_dayk/2 with invalid data returns error changeset" do
      dayk = dayk_fixture()
      assert {:error, %Ecto.Changeset{}} = Markets.update_dayk(dayk, @invalid_attrs)
      assert dayk == Markets.get_dayk!(dayk.symbol, dayk.date)
    end
  end
end
