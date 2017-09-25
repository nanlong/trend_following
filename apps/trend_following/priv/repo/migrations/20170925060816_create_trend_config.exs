defmodule TrendFollowing.Repo.Migrations.CreateTrendConfig do
  use Ecto.Migration

  def change do
    create table(:trend_config) do
      add :market, :string
      add :account, :decimal
      add :atr_rate, :decimal
      add :atr_add, :decimal
      add :stop_loss, :decimal
      add :position_max, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:trend_config, [:market])
    create index(:trend_config, [:user_id])
    create unique_index(:trend_config, [:market, :user_id])
  end
end
