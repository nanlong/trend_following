defmodule TrendFollowing.Repo.Migrations.CreateDayk do
  use Ecto.Migration

  def change do
    create table(:dayk) do
      add :symbol, :string
      add :date, :date
      add :open, :float
      add :close, :float
      add :high, :float
      add :low, :float
      add :pre_close, :float
      add :volume, :string
      add :ma5, :float
      add :ma10, :float
      add :ma20, :float
      add :ma30, :float
      add :ma50, :float
      add :ma300, :float
      add :high10, :float
      add :high20, :float
      add :high60, :float
      add :low10, :float
      add :low20, :float
      add :low60, :float
      add :tr, :float
      add :atr, :float

      timestamps()
    end

    create index(:dayk, [:symbol])
    create index(:dayk, [:date])
    create index(:dayk, [:ma50])
    create index(:dayk, [:ma300])
    create unique_index(:dayk, [:symbol, :date])
  end
end
