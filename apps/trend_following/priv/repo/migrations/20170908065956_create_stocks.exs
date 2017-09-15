defmodule TrendFollowing.Repo.Migrations.CreateStocks do
  use Ecto.Migration

  def change do
    create table(:stocks) do
      add :symbol, :string
      add :name, :string
      add :cname, :string
      add :category, :string
      add :market_cap, :string
      add :pe, :string
      add :market, :string
      add :lot_size, :integer
      add :trading_unit, :string
      add :price_quote, :string
      add :minimum_price_change, :string
      add :dayk_id, references(:dayk, on_delete: :nothing)

      timestamps()
    end

    create index(:stocks, [:symbol])
    create index(:stocks, [:market])
    create index(:stocks, [:dayk_id])
    create unique_index(:stocks, [:market, :symbol])
  end
end
