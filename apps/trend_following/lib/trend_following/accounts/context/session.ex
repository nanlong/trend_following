defmodule TrendFollowing.Accounts.SessionContext do
  alias TrendFollowing.Accounts.Session

  def create(attrs \\ %{}) do
    changeset = Session.changeset(%Session{}, attrs)
    
    if changeset.valid? do
      {:ok, Session.get_user(changeset)}
    else
      {:error, %{changeset | action: :create}}
    end
  end

  def change(%Session{} = session) do
    Session.changeset(session, %{})
  end
end