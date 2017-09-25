defmodule TrendFollowing.Repo.Migrations.CreateTrendConfig do
  use Ecto.Migration

  def change do
    create table(:trend_config) do
      add :market, :string
      add :account, :float
      add :atr_rate, :float
      add :atr_add, :float
      add :stop_loss, :float
      add :position_max, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:trend_config, [:market])
    create index(:trend_config, [:user_id])
    create unique_index(:trend_config, [:market, :user_id])
  end
end
