defmodule TrendFollowingWeb.HKStockControllerTest do
  use TrendFollowingWeb.ConnCase

  alias TrendFollowing.Markets

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:hk_stock) do
    {:ok, hk_stock} = Markets.create_hk_stock(@create_attrs)
    hk_stock
  end

  describe "index" do
    test "lists all stocks", %{conn: conn} do
      conn = get conn, hk_stock_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Stocks"
    end
  end

  describe "new hk_stock" do
    test "renders form", %{conn: conn} do
      conn = get conn, hk_stock_path(conn, :new)
      assert html_response(conn, 200) =~ "New Hk stock"
    end
  end

  describe "create hk_stock" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, hk_stock_path(conn, :create), hk_stock: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == hk_stock_path(conn, :show, id)

      conn = get conn, hk_stock_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Hk stock"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, hk_stock_path(conn, :create), hk_stock: @invalid_attrs
      assert html_response(conn, 200) =~ "New Hk stock"
    end
  end

  describe "edit hk_stock" do
    setup [:create_hk_stock]

    test "renders form for editing chosen hk_stock", %{conn: conn, hk_stock: hk_stock} do
      conn = get conn, hk_stock_path(conn, :edit, hk_stock)
      assert html_response(conn, 200) =~ "Edit Hk stock"
    end
  end

  describe "update hk_stock" do
    setup [:create_hk_stock]

    test "redirects when data is valid", %{conn: conn, hk_stock: hk_stock} do
      conn = put conn, hk_stock_path(conn, :update, hk_stock), hk_stock: @update_attrs
      assert redirected_to(conn) == hk_stock_path(conn, :show, hk_stock)

      conn = get conn, hk_stock_path(conn, :show, hk_stock)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, hk_stock: hk_stock} do
      conn = put conn, hk_stock_path(conn, :update, hk_stock), hk_stock: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Hk stock"
    end
  end

  describe "delete hk_stock" do
    setup [:create_hk_stock]

    test "deletes chosen hk_stock", %{conn: conn, hk_stock: hk_stock} do
      conn = delete conn, hk_stock_path(conn, :delete, hk_stock)
      assert redirected_to(conn) == hk_stock_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, hk_stock_path(conn, :show, hk_stock)
      end
    end
  end

  defp create_hk_stock(_) do
    hk_stock = fixture(:hk_stock)
    {:ok, hk_stock: hk_stock}
  end
end
