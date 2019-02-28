# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :yontaku,
  ecto_repos: [Yontaku.Repo]

# Configures the endpoint
config :yontaku, YontakuWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "M3JBYlgPQnMv0RMHPKb0IL7J8Y88AY4WIFcfaMXMlJ4fZrnfH5UyKYlLkBsh1upa",
  render_errors: [view: YontakuWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Yontaku.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# Configure LINE Messaging API
config :yontaku, Line,
  token: "QsDvT3EaZXyRyfXnkCm76pwwPJsLC/9iyQxq+HESrpcI3bkHvYuOHxFd0xHE9Ek5tMoVqqBxdka/h5MVrTR5zP+79H9Pn8B09PpV9zVnJC40Z2r/PF40CmD4wGSECT5wVFm1nt7gG0n6bYsuC8L59QdB04t89/1O/w1cDnyilFU=",
  url: "https://api.line.me/v2/bot"

config :yontaku, Yontaku,
  threshold: 3