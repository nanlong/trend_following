use Mix.Config

config :trend_following, ecto_repos: [TrendFollowing.Repo]

config :argon2_elixir,
  t_cost: 2,
  m_cost: 12

import_config "#{Mix.env}.exs"
