defmodule TrendFollowing.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :nickname, :string
      add :password_hash, :string
      add :vip_expire, :naive_datetime

      timestamps()
    end

    create unique_index(:users, ["lower(email)"])
    create index(:users, [:vip_expire])
  end
end
