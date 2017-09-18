defmodule TrendFollowingWeb.Graphql.Types.Future do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: TrendFollowing.Repo

  object :i_future do
    field :symbol, :string
    field :name, :string
    field :lot_size, :integer
    field :price, :float
    field :open, :float
    field :high, :float
    field :low, :float
    field :close, :float
    field :pre_close, :float
    field :volume, :integer
    field :diff, :float
    field :chg, :float
    field :buy_price, :float
    field :sell_price, :float
    field :open_positions, :float
    field :buy_positions, :float
    field :sell_positions, :float
    field :trading_unit, :string
    field :price_quote, :string
    field :minimum_price_change, :string
    field :datetime, :string
    field :timestamp, :string
  end

  object :g_future do
    field :symbol, :string
    field :name, :string
    field :lot_size, :integer
    field :price, :float
    field :open, :float
    field :high, :float
    field :low, :float
    field :close, :float
    field :pre_close, :float
    field :volume, :integer
    field :diff, :float
    field :chg, :float
    field :buy_price, :float
    field :sell_price, :float
    field :open_positions, :float
    field :buy_positions, :float
    field :sell_positions, :float
    field :trading_unit, :string
    field :price_quote, :string
    field :minimum_price_change, :string
    field :datetime, :string
    field :timestamp, :string
  end
end