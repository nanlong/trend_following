defmodule TrendFollowing.Accounts.PasswordResetContext do
  alias TrendFollowing.Accounts.PasswordReset

  def change(attrs \\ %{}) do
    %PasswordReset{}
    |> PasswordReset.changeset(attrs)
  end

  def create(attrs \\ %{}) do
    changeset = change(attrs)
    
    if changeset.valid? do
      {:ok, PasswordReset.get_user(changeset)}
    else
      {:error, %{changeset | action: :create}}
    end
  end
end