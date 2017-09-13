defmodule TrendFollowingWeb.Graphql.Types.Stock do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: TrendFollowing.Repo


  object :hk_stock do
    field :symbol, :string
    field :name, :string
    field :cname, :string
    field :lot_size, :integer
    field :price, :float
    field :diff, :float
    field :chg, :float
    field :pre_close, :float
    field :open, :float
    field :amount, :float
    field :volume, :integer
    field :high, :float
    field :low, :float
    field :year_high, :float
    field :year_low, :float
    field :amplitude, :float
    field :pe, :float
    field :total_capital, :integer
    field :hk_capital, :integer
    field :hk_market_cap, :float
    field :dividend_yield, :float
    field :datetime, :string
    field :timestamp, :integer
  end
end