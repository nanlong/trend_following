defmodule TrendFollowingWeb.PasswordResetController do
  use TrendFollowingWeb, :controller

  alias TrendFollowing.Accounts
  alias TrendFollowingWeb.Helpers.Email

  def show(conn, %{"token" => token}) do
    case verify_token(conn, token) do
      {:ok, user} ->
        changeset = Accounts.change_user_password_reset(user)

        conn
        |> assign(:title, "密码重置")
        |> assign(:user, user)
        |> assign(:token, token)
        |> assign(:changeset, changeset)
        |> render(:reset)
      {:error, :invalid} ->
        conn
        |> put_flash(:error, "重置密码链接不正确")
        |> redirect(to: password_reset_path(conn, :show))
      {:error, :expired} ->
        conn
        |> put_flash(:error, "重置密码链接已过期")
        |> redirect(to: password_reset_path(conn, :show))
    end
  end

  def show(conn, _params) do
    changeset = Accounts.change_password_reset(%{})

    conn
    |> assign(:title, "找回密码")
    |> assign(:changeset, changeset)
    |> render(:show)
  end

  def create(conn, %{"password_reset" => password_reset_params}) do
    case Accounts.create_password_reset(password_reset_params) do
      {:ok, user} ->
        Email.password_reset(user, sign_token(conn, user))
        
        conn
        |> assign(:title, "邮件已发送")
        |> render(:success)
      {:error, changeset} ->
        conn
        |> assign(:title, "找回密码")
        |> assign(:changeset, changeset)
        |> render(:show)
    end
  end

  def update(conn, %{"token" => token, "user" => user_params}) do
    with {:ok, user} <- verify_token(conn, token),
      {:ok, _user} <- Accounts.update_user_password_reset(user, user_params) do
      conn
      |> put_flash(:info, "密码重置成功，请登陆")
      |> redirect(to: session_path(conn, :create))
    else
      {:error, :invalid} ->
        conn
        |> put_flash(:error, "重置密码链接不正确")
        |> redirect(to: password_reset_path(conn, :new))
      {:error, :expired} ->
        conn
        |> put_flash(:error, "重置密码链接已过期")
        |> redirect(to: password_reset_path(conn, :new))
      {:error, changeset} ->
        conn
        |> assign(:title, "密码重置")
        |> assign(:user, changeset.data)
        |> assign(:token, token)
        |> assign(:changeset, changeset)
        |> render(:reset)
    end
  end
end
