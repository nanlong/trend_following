defmodule TrendFollowingWeb.SettingView do
  use TrendFollowingWeb, :view

  def nav_data(conn) do
    [
      {"账号信息", "profile", setting_path(conn, :show, "profile")},
    ]
  end
end
