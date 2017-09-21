defmodule TrendFollowingWeb.UserControllerTest do
  use TrendFollowingWeb.ConnCase

  @create_attrs %{email: "test@trendfollowing.cc", password: "123456", password_confirmation: "123456"}
  @invalid_attrs %{email: nil, password: nil, password_confirmation: nil}

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get conn, user_path(conn, :new)
      assert html_response(conn, 200) =~ "用户注册"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @create_attrs
      assert redirected_to(conn) == market_path(conn, :show)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert html_response(conn, 200) =~ "用户注册"
    end
  end
end
