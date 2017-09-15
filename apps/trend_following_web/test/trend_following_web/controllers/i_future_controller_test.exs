defmodule TrendFollowingWeb.IFutureControllerTest do
  use TrendFollowingWeb.ConnCase

  alias TrendFollowing.Markets

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:i_future) do
    {:ok, i_future} = Markets.create_i_future(@create_attrs)
    i_future
  end

  describe "index" do
    test "lists all futures", %{conn: conn} do
      conn = get conn, i_future_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Futures"
    end
  end

  describe "new i_future" do
    test "renders form", %{conn: conn} do
      conn = get conn, i_future_path(conn, :new)
      assert html_response(conn, 200) =~ "New I future"
    end
  end

  describe "create i_future" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, i_future_path(conn, :create), i_future: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == i_future_path(conn, :show, id)

      conn = get conn, i_future_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show I future"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, i_future_path(conn, :create), i_future: @invalid_attrs
      assert html_response(conn, 200) =~ "New I future"
    end
  end

  describe "edit i_future" do
    setup [:create_i_future]

    test "renders form for editing chosen i_future", %{conn: conn, i_future: i_future} do
      conn = get conn, i_future_path(conn, :edit, i_future)
      assert html_response(conn, 200) =~ "Edit I future"
    end
  end

  describe "update i_future" do
    setup [:create_i_future]

    test "redirects when data is valid", %{conn: conn, i_future: i_future} do
      conn = put conn, i_future_path(conn, :update, i_future), i_future: @update_attrs
      assert redirected_to(conn) == i_future_path(conn, :show, i_future)

      conn = get conn, i_future_path(conn, :show, i_future)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, i_future: i_future} do
      conn = put conn, i_future_path(conn, :update, i_future), i_future: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit I future"
    end
  end

  describe "delete i_future" do
    setup [:create_i_future]

    test "deletes chosen i_future", %{conn: conn, i_future: i_future} do
      conn = delete conn, i_future_path(conn, :delete, i_future)
      assert redirected_to(conn) == i_future_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, i_future_path(conn, :show, i_future)
      end
    end
  end

  defp create_i_future(_) do
    i_future = fixture(:i_future)
    {:ok, i_future: i_future}
  end
end
