defmodule TrendFollowing.Markets.TrendConfig do
  use Ecto.Schema
  import Ecto.Changeset
  alias TrendFollowing.Markets.TrendConfig


  schema "trend_config" do
    field :market, :string
    field :account, :decimal
    field :atr_rate, :decimal
    field :atr_add, :decimal
    field :stop_loss, :decimal
    field :position_max, :integer
    
    belongs_to :user, TrendFollowing.Accounts.User

    timestamps()
  end

  @required_fields ~w(market account atr_rate atr_add stop_loss position_max user_id)a
  @optional_fields ~w()a

  @doc false
  def changeset(%TrendConfig{} = trend_config, attrs) do
    trend_config
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:user)
    |> validate_inclusion(:market, ["cn_stock", "hk_stock", "us_stock", "i_future", "g_future"])
  end
end
