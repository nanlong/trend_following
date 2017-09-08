defmodule TrendFollowing.Markets.Stock do
  use Ecto.Schema
  import Ecto.Changeset
  alias TrendFollowing.Markets.Stock


  schema "stocks" do
    field :market, :string
    field :symbol, :string
    field :name, :string
    field :cname, :string
    field :category, :string
    field :market_cap, :string
    field :pe, :string
    field :lot_size, :integer

    belongs_to :dayk, TrendFollowing.Markets.Dayk

    timestamps()
  end

  @required_fields ~w(market symbol name cname lot_size)a
  @optional_fields ~w(category market_cap pe dayk_id)a

  @doc false
  def changeset(%Stock{} = stock, attrs) do
    stock
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
