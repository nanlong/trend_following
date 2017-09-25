defmodule TrendFollowing.Markets.Context.TrendConfig do
  import Ecto.Query, warn: false
  alias TrendFollowing.Repo
  alias TrendFollowing.Markets.TrendConfig

  def create(attrs \\ %{}) do
    %TrendConfig{}
    |> TrendConfig.changeset(attrs)
    |> Repo.insert()
  end

  def update(%TrendConfig{} = trend_config, attrs) do
    trend_config
    |> TrendConfig.changeset(attrs)
    |> Repo.update()
  end

  def get(user_id, market) do
    Repo.get_by(TrendConfig, user_id: user_id, market: market)
  end

  def change(%TrendConfig{} = trend_config) do
    TrendConfig.changeset(trend_config, %{})
  end
end