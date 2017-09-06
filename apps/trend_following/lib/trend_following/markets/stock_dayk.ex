defmodule TrendFollowing.Markets.StockDayk do
  use Ecto.Schema
  import Ecto.Changeset
  alias TrendFollowing.Markets.StockDayk


  schema "stock_dayk" do
    field :symbol, :string
    field :date, :date
    field :open, :float
    field :close, :float
    field :high, :float
    field :low, :float
    field :volume, :integer
    field :pre_close, :float
    field :ma5, :float
    field :ma10, :float
    field :ma20, :float
    field :ma30, :float
    field :ma50, :float
    field :ma300, :float
    field :tr, :float
    field :atr, :float

    timestamps()
  end

  @required_fields ~w(symbol date open close high low volume)a
  @optional_fields ~w(pre_close ma5 ma10 ma20 ma30 ma50 ma300 tr atr)a

  @doc false
  def changeset(%StockDayk{} = stock, attrs) do
    stock
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
