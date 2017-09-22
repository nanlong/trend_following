defmodule TrendFollowing.Accounts.UserContext do
  import Ecto.Query, warn: false
  alias TrendFollowing.Repo

  alias TrendFollowing.Accounts.User

  def vip?(%{vip_expire: vip_expire}) when is_nil(vip_expire), do: false
  def vip?(user) do 
    now = DateTime.utc_now()
    vip_expire = DateTime.from_naive!(user.vip_expire, "Etc/UTC")
    if DateTime.compare(now, vip_expire) == :lt, do: true, else: false
  end

  def get_by_id(id), do: Repo.get(User, id)
  def get(email), do: Repo.get_by(User, email: email)
  def get!(email), do: Repo.get_by!(User, email: email)

  def create(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
  
  def update_profile(%User{} = user, attrs) do
    user
    |> User.changeset_profile(attrs)
    |> Repo.update()
  end
  def update_password(%User{} = user, attrs) do
    user
    |> User.changeset_password(attrs)
    |> Repo.update()
  end
  def update_password_reset(%User{} = user, attrs) do
    user
    |> User.changeset_password_reset(attrs)
    |> Repo.update()
  end

  def change(%User{} = user \\ %User{}) do
    User.changeset(user, %{})
  end
  def change_profile(%User{} = user \\ %User{}) do
    User.changeset_profile(user, %{})
  end
  def change_password(%User{} = user \\ %User{}) do
    User.changeset_password(user, %{})
  end
  def change_password_reset(%User{} = user \\ %User{}) do
    User.changeset_password_reset(user, %{})
  end
end