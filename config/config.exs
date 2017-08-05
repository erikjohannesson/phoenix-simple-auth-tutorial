# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :simple_auth,
  ecto_repos: [SimpleAuth.Repo]

# Configures the endpoint
config :simple_auth, SimpleAuthWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "s5ByndokEo9jtsDO+M01C/bHMfFKO0KBksrzl6aAOo63pH/Qx4W/NDtyD/vY3Cfa",
  render_errors: [view: SimpleAuthWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SimpleAuth.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  issuer: "SimpleAuth.#{Mix.env}",
  ttl: {30, :days},
  allowed_drift: 2000,
  verify_issuer: true,
  serializer: SimpleAuth.Accounts.GuardianSerializer,
  secret_key: to_string(Mix.env) <> "thisIsNOTaVERYgoodSecret"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
