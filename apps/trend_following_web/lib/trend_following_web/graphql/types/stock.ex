defmodule TrendFollowingWeb.Graphql.Types.Stock do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: TrendFollowing.Repo

  object :cn_stock do
    field :symbol, :string
    field :name, :string
    field :price, :float
    field :open, :float
    field :high, :float
    field :low, :float
    field :pre_close, :float
    field :volume, :integer
    field :amount, :float
    field :market_cap, :integer
    field :cur_market_cap, :integer
    field :turnover, :float
    field :pb, :float
    field :pe, :float
    field :diff, :float
    field :chg, :float
    field :amplitude, :float
    field :datetime, :string
    field :timestamp, :integer
  end

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

  object :us_stock do
    field :symbol, :string
    field :cname, :string
    field :price, :float
    field :open, :float
    field :high, :float
    field :low, :float
    field :pre_close, :float
    field :year_high, :float
    field :year_low, :float
    field :diff, :float
    field :chg, :float
    field :volume, :integer
    field :volume_d10_avg, :integer
    field :market_cap, :string
    field :eps, :string
    field :pe, :string
    field :beta, :string
    field :dividend, :string
    field :yield, :string
    field :capital, :string
    field :pre_close_datetime, :string
    field :datetime, :string
    field :timestamp, :integer
  end
end