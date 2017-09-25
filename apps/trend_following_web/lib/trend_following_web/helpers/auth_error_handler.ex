defmodule TrendFollowingWeb.Helpers.AuthErrorHandler do
  use TrendFollowingWeb, :controller

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_flash(:info, "需要登录.")
    |> redirect(to: session_path(conn, :create))
  end
end