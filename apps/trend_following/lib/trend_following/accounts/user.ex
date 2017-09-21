defmodule TrendFollowing.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias TrendFollowing.Accounts.User


  schema "users" do
    field :email, :string
    field :nickname, :string
    field :password_hash, :string
    field :vip_expire, :naive_datetime

    timestamps()

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :old_password, :string, virtual: true
  end

  @required_fields ~w(email password password_confirmation)a
  @optional_fields ~w(vip_expire)a
  @regex_email ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
  
  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields, message: "不能为空")
    |> unique_constraint(:email, name: :users_lower_email_index, message: "邮箱已存在")
    |> validate_format(:email, @regex_email, message: "请输入正确的邮箱地址")
    |> validate_length(:password, min: 6, max: 128, message: "密码长度6-128位")
    |> validate_confirmation(:password, message: "两次输入密码不一致")
    |> put_password_hash
    |> put_nickname
    |> put_vip(30)
  end

  def changeset_profile(%User{} = user, attrs) do
    user
    |> cast(attrs, [:nickname])
    |> validate_required([:nickname], message: "不能为空")
  end

  def changeset_password(%User{} = user, attrs) do
    user
    |> cast(attrs, [:old_password, :password, :password_confirmation])
    |> validate_required([:old_password, :password, :password_confirmation], message: "不能为空")
    |> checkpw(:old_password, message: "密码输入不正确")
    |> validate_length(:password, min: 6, max: 128, message: "密码长度6-128位")
    |> validate_confirmation(:password, message: "两次输入密码不一致")
    |> put_password_hash
  end

  def changeset_password_reset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:password, :password_confirmation])
    |> validate_required([:password, :password_confirmation], message: "不能为空")
    |> validate_length(:password, min: 6, max: 128, message: "密码长度6-128位")
    |> validate_confirmation(:password, message: "两次输入密码不一致")
    |> put_password_hash
  end

  defp put_password_hash(%Ecto.Changeset{valid?: false} = changeset), do: changeset
  defp put_password_hash(%Ecto.Changeset{changes: 
    %{password: password}} = changeset) do
    change(changeset, Comeonin.Argon2.add_hash(password))
  end

  defp put_nickname(%{valid?: false} = changeset), do: changeset
  defp put_nickname(%Ecto.Changeset{changes: 
    %{email: email}} = changeset) do
    change(changeset, nickname: email |> String.split("@") |> List.first)
  end

  defp checkpw(changeset, field, options) do
    validate_change(changeset, field, fn _, password -> 
      case Comeonin.Argon2.check_pass(changeset.data, password) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  defp put_vip(%{valid?: false} = changeset, _days), do: changeset
  defp put_vip(changeset, days) do
    vip_expire = Timex.add(Timex.now, Timex.Duration.from_days(days)) |> Timex.to_datetime()
    change(changeset, vip_expire: vip_expire)
  end
end
