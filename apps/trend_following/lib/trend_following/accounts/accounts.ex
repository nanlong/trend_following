defmodule TrendFollowing.Accounts do
  alias TrendFollowing.Accounts.UserContext

  defdelegate create_user(attrs), to: UserContext, as: :create
  defdelegate get_user!(email), to: UserContext, as: :get!
  defdelegate update_user_profile(user, attrs), to: UserContext, as: :update_profile
  defdelegate update_user_password(user, attrs), to: UserContext, as: :update_password
  defdelegate update_user_password_reset(user, attrs), to: UserContext, as: :update_password_reset
  defdelegate change_user(user), to: UserContext, as: :change
  defdelegate change_user_profile(user), to: UserContext, as: :change_profile
  defdelegate change_user_password(user), to: UserContext, as: :change_password
  defdelegate change_user_password_reset(user), to: UserContext, as: :change_password_reset
end
