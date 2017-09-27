defmodule TrendFollowing.Accounts.PasswordReset do
  use Ecto.Schema

  import Ecto.Changeset

  alias TrendFollowing.Accounts

  embedded_schema do
    field :email, :string, virtual: true
  end

  @required_fields ~w(email)a

  def changeset(struct, params) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields, message: "不能为空")
    |> validate_user_with_email()
  end

  defp validate_user_with_email(%{valid?: false} = changeset), do: changeset
  defp validate_user_with_email(changeset) do
    email = get_field(changeset, :email)
    
    case Accounts.get_user(email) do
      nil -> add_error(changeset, :email, "用户不存在")
      user -> put_change(changeset, :user, user)
    end
  end

  def get_user(%Ecto.Changeset{} = changeset) do
    get_field(changeset, :user)
  end
end