use Mix.Config

config :trend_following, ecto_repos: [TrendFollowing.Repo]

import_config "#{Mix.env}.exs"
