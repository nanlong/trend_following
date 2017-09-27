defmodule TrendFollowingWeb.Helpers.Controller do
  alias TrendFollowing.Accounts
  
  def current_user(%{assigns: %{current_user: current_user}}), do: current_user
  def current_user(_), do: nil

  def convert_trend_config(trend_config) do
    trend_config
    |> Map.update!(:account, &(Decimal.to_float(&1)))
    |> Map.update!(:atr_rate, &(Decimal.to_float(&1) / 100))
    |> Map.update!(:atr_add, &(Decimal.to_float(&1)))
    |> Map.update!(:stop_loss, &(Decimal.to_float(&1) / 100))
  end

  def sign_token(conn, user, token_name \\ "user_id") do
    Phoenix.Token.sign(conn, token_name, user.id)
  end

  def verify_token(conn, token, token_name \\ "user_id", max_age \\ 60 * 60 * 12 * 30) do
    case Phoenix.Token.verify(conn, token_name, token, max_age: max_age) do
      {:ok, user_id} -> 
        case Accounts.get_user_by_id(user_id) do
          nil -> {:error, "invalid authorization token"}
          user -> {:ok, user}
        end
      {:error, _} -> {:error, "invalid authorization token"}
    end
  end
end