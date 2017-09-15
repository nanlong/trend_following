defmodule TrendFollowing.Markets.Future do
  use Ecto.Schema
  import Ecto.Changeset
  alias TrendFollowing.Markets.Future


  schema "futures" do
    field :symbol, :string
    field :name, :string
    field :market, :string
    field :lot_size, :integer
    field :trading_unit, :string
    field :price_quote, :string
    field :minimum_price_change, :string
    
    belongs_to :dayk, TrendFollowing.Markets.Dayk

    timestamps()
  end

  @required_fields ~w(symbol name market)a
  @optional_fields ~w(lot_size trading_unit price_quote minimum_price_change dayk_id)

  @doc false
  def changeset(%Future{} = future, attrs) do
    future
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
