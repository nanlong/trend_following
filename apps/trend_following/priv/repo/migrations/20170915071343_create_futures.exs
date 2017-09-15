defmodule TrendFollowing.Repo.Migrations.CreateFutures do
  use Ecto.Migration

  def change do
    create table(:futures) do
      add :name, :string
      add :symbol, :string
      add :lot_size, :integer
      add :market, :string
      add :trading_unit, :string
      add :price_quote, :string
      add :minimum_price_change, :string
      add :dayk_id, references(:dayk, on_delete: :nothing)

      timestamps()
    end

    create index(:futures, [:name])
    create index(:futures, [:market])
    create index(:futures, [:dayk_id])
    create unique_index(:futures, [:symbol])
  end
end
