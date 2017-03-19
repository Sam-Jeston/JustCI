# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :just_ci,
  ecto_repos: [JustCi.Repo]

# Configures the endpoint
config :just_ci, JustCi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "fka+c35oYEiXTXRke5claKbM5TRC95+g8pMMs+ysLDjK6Gc6giR+GsCtCHhSrl9J",
  render_errors: [view: JustCi.ErrorView, accepts: ~w(html json)],
  pubsub: [name: JustCi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
