defmodule TrendFollowingWeb.SettingController do
  use TrendFollowingWeb, :controller

  alias TrendFollowing.Accounts
  alias TrendFollowing.Markets

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

  def show(conn, %{"page" => "trend_config"} = params) do
    market = Map.get(params, "tab", "cn_stock")

    current_user = current_user(conn)

    trend_config = 
      case Markets.get_trend_config(current_user.id, market) do
        nil -> Markets.default_trend_config(market)
        trend_config -> trend_config
      end
    
    title =
      case market do
        "cn_stock" -> "沪深市场配置"
        "hk_stock" -> "港股市场配置"
        "us_stock" -> "美股市场配置"
        "i_future" -> "国内期货市场配置"
        "g_future" -> "外盘期货市场配置"
      end
    
    conn
    |> assign(:title, title)
    |> assign(:params, params)
    |> assign(:changeset, Markets.change_trend_config(trend_config))
    |> render(:show_trend_config)
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
  
  def update(conn, %{"page" => "trend_config", "trend_config" => trend_config_params} = params) do
    market = Map.get(params, "tab", "cn_stock")
    current_user = current_user(conn)
    
    result =
      case Markets.get_trend_config(current_user.id, market) do
        nil -> Markets.create_trend_config(Enum.into(trend_config_params, %{"user_id" => current_user.id, "market" => market}))
        trend_config -> Markets.update_trend_config(trend_config, trend_config_params)
      end

    case result do
      {:ok, _trend_config} ->
        conn
        |> put_flash(:info, "更新市场配置成功")
        |> redirect(to: setting_path(conn, :show, "trend_config", tab: market))

      {:error, changeset} ->
        title =
          case market do
            "cn_stock" -> "沪深市场配置"
            "hk_stock" -> "港股市场配置"
            "us_stock" -> "美股市场配置"
            "i_future" -> "国内期货市场配置"
            "g_future" -> "外盘期货市场配置"
          end
        
        conn
        |> assign(:title, title)
        |> assign(:params, params)
        |> assign(:changeset, changeset)
        |> render(:show_trend_config)
    end
  end
end
