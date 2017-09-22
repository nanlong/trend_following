defmodule TrendFollowingWeb.SessionController do
  use TrendFollowingWeb, :controller

  alias TrendFollowing.Accounts
  alias TrendFollowing.Accounts.Session
  alias TrendFollowingWeb.Helpers.Guardian

  def new(conn, _params) do
    changeset = Accounts.change_session(%Session{})

    conn
    |> assign(:title, "用户登录")
    |> assign(:changeset, changeset)
    |> render(:new)
  end

  def create(conn, %{"session" => session_params}) do
    case Accounts.create_session(session_params) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        # |> put_resp_cookie("token", Accounts.sign_token(user), [http_only: false])
        |> put_flash(:info, "登录成功.")
        |> redirect(to: market_path(conn, :show))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:title, "用户登录")
        |> assign(:changeset, changeset)
        |> render(:new)
    end
  end

  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> delete_resp_cookie("token")
    |> put_flash(:info, "退出登录.")
    |> redirect(to: page_path(conn, :index))
  end
end
