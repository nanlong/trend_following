defmodule TrendFollowingWeb.Helpers.Controller do
  
  def current_user(%{assigns: %{current_user: current_user}}), do: current_user
  def current_user(_), do: nil
end