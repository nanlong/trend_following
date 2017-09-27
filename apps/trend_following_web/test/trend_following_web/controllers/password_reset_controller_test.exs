defmodule TrendFollowingWeb.PasswordResetControllerTest do
  use TrendFollowingWeb.ConnCase

  alias TrendFollowing.Accounts

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:password_reset) do
    {:ok, password_reset} = Accounts.create_password_reset(@create_attrs)
    password_reset
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, password_reset_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new password_reset" do
    test "renders form", %{conn: conn} do
      conn = get conn, password_reset_path(conn, :new)
      assert html_response(conn, 200) =~ "New Password reset"
    end
  end

  describe "create password_reset" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, password_reset_path(conn, :create), password_reset: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == password_reset_path(conn, :show, id)

      conn = get conn, password_reset_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Password reset"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, password_reset_path(conn, :create), password_reset: @invalid_attrs
      assert html_response(conn, 200) =~ "New Password reset"
    end
  end

  describe "edit password_reset" do
    setup [:create_password_reset]

    test "renders form for editing chosen password_reset", %{conn: conn, password_reset: password_reset} do
      conn = get conn, password_reset_path(conn, :edit, password_reset)
      assert html_response(conn, 200) =~ "Edit Password reset"
    end
  end

  describe "update password_reset" do
    setup [:create_password_reset]

    test "redirects when data is valid", %{conn: conn, password_reset: password_reset} do
      conn = put conn, password_reset_path(conn, :update, password_reset), password_reset: @update_attrs
      assert redirected_to(conn) == password_reset_path(conn, :show, password_reset)

      conn = get conn, password_reset_path(conn, :show, password_reset)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, password_reset: password_reset} do
      conn = put conn, password_reset_path(conn, :update, password_reset), password_reset: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Password reset"
    end
  end

  describe "delete password_reset" do
    setup [:create_password_reset]

    test "deletes chosen password_reset", %{conn: conn, password_reset: password_reset} do
      conn = delete conn, password_reset_path(conn, :delete, password_reset)
      assert redirected_to(conn) == password_reset_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, password_reset_path(conn, :show, password_reset)
      end
    end
  end

  defp create_password_reset(_) do
    password_reset = fixture(:password_reset)
    {:ok, password_reset: password_reset}
  end
end
