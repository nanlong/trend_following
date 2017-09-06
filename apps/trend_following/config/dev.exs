use Mix.Config

# Configure your database
config :trend_following, TrendFollowing.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "trend_following_dev",
  hostname: "localhost",
  pool_size: 10
