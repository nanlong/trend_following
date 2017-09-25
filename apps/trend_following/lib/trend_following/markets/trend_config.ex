defmodule TrendFollowing.Markets.TrendConfig do
  use Ecto.Schema
  import Ecto.Changeset
  alias TrendFollowing.Markets.TrendConfig


  schema "trend_config" do
    field :market, :string
    field :account, :float
    field :atr_rate, :float
    field :atr_add, :float
    field :stop_loss, :float
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
    |> validate_inclusion(:atr_rate, [0.5, 1.0, 1.5, 2.0])
    |> validate_inclusion(:atr_add, [0.5, 1.0, 1.5, 2.0])
    |> validate_inclusion(:stop_loss, [0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0])
    |> validate_inclusion(:position_max, [1, 2, 3, 4, 5, 6, 7, 8])
  end
end
