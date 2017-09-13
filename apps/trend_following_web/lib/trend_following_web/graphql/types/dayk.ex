defmodule TrendFollowingWeb.Graphql.Types.Dayk do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: TrendFollowing.Repo

  
  object :dayk do
    field :symbol, :string
    field :date, :string
    field :open, :float
    field :close, :float
    field :high, :float
    field :low, :float
    field :volume, :string
    field :pre_close, :float
    field :ma5, :float
    field :ma10, :float
    field :ma20, :float
    field :ma30, :float
    field :ma50, :float
    field :ma300, :float
    field :high10, :float
    field :high20, :float
    field :high60, :float
    field :low10, :float
    field :low20, :float
    field :low60, :float
    field :tr, :float
    field :atr, :float
  end
end