defmodule TrendFollowing.Repo.Migrations.CreateStockDayk do
  use Ecto.Migration

  def change do
    create table(:stock_dayk) do
      add :symbol, :string
      add :date, :date
      add :open, :float
      add :close, :float
      add :high, :float
      add :low, :float
      add :pre_close, :float
      add :volume, :integer
      add :ma5, :float
      add :ma10, :float
      add :ma20, :float
      add :ma30, :float
      add :ma50, :float
      add :ma300, :float
      add :tr, :float
      add :atr, :float

      timestamps()
    end

    create index(:stock_dayk, [:symbol])
    create index(:stock_dayk, [:date])
    create index(:stock_dayk, [:ma50])
    create index(:stock_dayk, [:ma300])
    create unique_index(:stock_dayk, [:symbol, :date])
  end
end
