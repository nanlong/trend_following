defmodule TrendFollowingWeb.SettingView do
  use TrendFollowingWeb, :view

  def nav_data(conn) do
    [
      {"账号信息", "profile", setting_path(conn, :show, "profile")},
      {"市场配置", "trend_config", setting_path(conn, :show, "trend_config")},
    ]
  end

  def trend_config_tabs_data(conn) do
    [
      {"沪深", "cn_stock", setting_path(conn, :show, "trend_config", tab: "cn_stock")},
      {"港股", "hk_stock", setting_path(conn, :show, "trend_config", tab: "hk_stock")},
      {"美股", "us_stock", setting_path(conn, :show, "trend_config", tab: "us_stock")},
      {"国内期货", "i_future", setting_path(conn, :show, "trend_config", tab: "i_future")},
      {"外盘期货", "g_future", setting_path(conn, :show, "trend_config", tab: "g_future")},
    ]
  end
end
