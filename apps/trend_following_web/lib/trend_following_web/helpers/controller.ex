defmodule TrendFollowingWeb.Helpers.Controller do
  
  def current_user(%{assigns: %{current_user: current_user}}), do: current_user
  def current_user(_), do: nil

  def convert_trend_config(trend_config) do
    trend_config
    |> Map.update!(:account, &(Decimal.to_float(&1)))
    |> Map.update!(:atr_rate, &(Decimal.to_float(&1) / 100))
    |> Map.update!(:atr_add, &(Decimal.to_float(&1)))
    |> Map.update!(:stop_loss, &(Decimal.to_float(&1) / 100))
  end
end