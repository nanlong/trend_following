defmodule TrendFollowingWeb.GFutureControllerTest do
  use TrendFollowingWeb.ConnCase

  alias TrendFollowing.Markets

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:g_future) do
    {:ok, g_future} = Markets.create_g_future(@create_attrs)
    g_future
  end

  describe "index" do
    test "lists all futures", %{conn: conn} do
      conn = get conn, g_future_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Futures"
    end
  end

  describe "new g_future" do
    test "renders form", %{conn: conn} do
      conn = get conn, g_future_path(conn, :new)
      assert html_response(conn, 200) =~ "New G future"
    end
  end

  describe "create g_future" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, g_future_path(conn, :create), g_future: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == g_future_path(conn, :show, id)

      conn = get conn, g_future_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show G future"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, g_future_path(conn, :create), g_future: @invalid_attrs
      assert html_response(conn, 200) =~ "New G future"
    end
  end

  describe "edit g_future" do
    setup [:create_g_future]

    test "renders form for editing chosen g_future", %{conn: conn, g_future: g_future} do
      conn = get conn, g_future_path(conn, :edit, g_future)
      assert html_response(conn, 200) =~ "Edit G future"
    end
  end

  describe "update g_future" do
    setup [:create_g_future]

    test "redirects when data is valid", %{conn: conn, g_future: g_future} do
      conn = put conn, g_future_path(conn, :update, g_future), g_future: @update_attrs
      assert redirected_to(conn) == g_future_path(conn, :show, g_future)

      conn = get conn, g_future_path(conn, :show, g_future)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, g_future: g_future} do
      conn = put conn, g_future_path(conn, :update, g_future), g_future: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit G future"
    end
  end

  describe "delete g_future" do
    setup [:create_g_future]

    test "deletes chosen g_future", %{conn: conn, g_future: g_future} do
      conn = delete conn, g_future_path(conn, :delete, g_future)
      assert redirected_to(conn) == g_future_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, g_future_path(conn, :show, g_future)
      end
    end
  end

  defp create_g_future(_) do
    g_future = fixture(:g_future)
    {:ok, g_future: g_future}
  end
end
