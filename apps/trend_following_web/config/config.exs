# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :trend_following_web,
  namespace: TrendFollowingWeb,
  ecto_repos: [TrendFollowing.Repo]

# Configures the endpoint
config :trend_following_web, TrendFollowingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/NIlFR2PQMHU0nAlvYBh/QbPbObz8ii4PpOkkvsWb4bUeOICwJlx+PtBH78gvzHf",
  render_errors: [view: TrendFollowingWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TrendFollowingWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :trend_following_web, :generators,
  context_app: :trend_following

config :scrivener_html,
  routes_helper: TrendFollowingWeb.Router.Helpers,
  view_style: :bulma

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
