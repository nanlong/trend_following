defmodule TrendFollowingWeb.SettingController do
  use TrendFollowingWeb, :controller

  alias TrendFollowing.Accounts

  def index(conn, _params), do: redirect(conn, to: setting_path(conn, :show, "profile"))

  def show(conn, %{"page" => "profile"} = params) do
    current_user = current_user(conn)

    conn
    |> assign(:title, "用户信息")
    |> assign(:params, params)
    |> assign(:change_profile, Accounts.change_user(current_user))
    |> assign(:change_password, Accounts.change_user_password(current_user))
    |> render(:show_profile)
  end

  def update(conn, %{"page" => "profile", "user" => user_params} = params) do
    current_user = current_user(conn)

    case Accounts.update_user_profile(current_user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "修改个人信息成功！")
        |> redirect(to: setting_path(conn, :show, "profile"))

      {:error, changeset} ->
        conn
        |> assign(:title, "用户信息")
        |> assign(:params, params)
        |> assign(:change_profile, changeset)
        |> assign(:change_password, Accounts.change_user_password(current_user))
        |> render(:show_profile)
    end
  end

  def update(conn, %{"page" => "password", "user" => user_params} = params) do
    current_user = current_user(conn)

    case Accounts.update_user_password(current_user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "修改密码成功！")
        |> redirect(to: setting_path(conn, :show, "profile"))

      {:error, changeset} ->
        conn
        |> assign(:title, "用户信息")
        |> assign(:params, params)
        |> assign(:change_profile, Accounts.change_user(current_user))
        |> assign(:change_password, changeset)
        |> render(:show_profile)
    end
  end
end
