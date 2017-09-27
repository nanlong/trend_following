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

config :trend_following_web, TrendFollowingWeb.Helpers.Guardian,
  issuer: "trend_following_web",
  secret_key: "QsRsnw/6QHX8qrTgR3T511Go+2rXT4AMCoXgITRo24MgV837JmA3KEt+sbWX2I/5"

config :trading_system_web, TrendFollowingWeb.Helpers.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: "key-bb2d3d19408d7ccf5abc25e0a9281cd7",
  domain: "mg.trendfollowing.cc"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
