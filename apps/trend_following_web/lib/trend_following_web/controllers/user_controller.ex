defmodule TrendFollowingWeb.UserController do
  use TrendFollowingWeb, :controller

  alias TrendFollowing.Accounts
  alias TrendFollowing.Accounts.User
  alias TrendFollowingWeb.Helpers.Guardian
  alias TrendFollowingWeb.Helpers.Email

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})

    conn
    |> assign(:title, "用户注册")
    |> assign(:changeset, changeset)
    |> render(:new)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        Email.welcome(user.email)
        
        conn
        |> put_flash(:info, "注册成功")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: market_path(conn, :show))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:title, "用户注册")
        |> assign(:changeset, changeset)
        |> render(:new)
    end
  end
end
