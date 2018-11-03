# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :polymorphic_productions,
  ecto_repos: [PolymorphicProductions.Repo]

# Configures the endpoint
config :polymorphic_productions, PolymorphicProductionsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3PiqBs6QqAwrSbvLmywSxI1uriZoqgZ46yi6EMpxmmS1KG1xYC2NTB1HsjDnSawp",
  render_errors: [view: PolymorphicProductionsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PolymorphicProductions.PubSub, adapter: Phoenix.PubSub.PG2]

# Phauxth authentication configuration
# config :phauxth,
#   token_salt: "5W3bQee3",
#   endpoint: PolymorphicProductionsWeb.Endpoint

config :phauxth,
  user_context: PolymorphicProductions.Accounts,
  token_module: PolymorphicProductionsWeb.Auth.Token

# Mailer configuration
config :polymorphic_productions, PolymorphicProductionsWeb.Mailer, adapter: Bamboo.LocalAdapter

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix and Ecto
config :phoenix, :json_library, Jason
config :ecto, :json_library, Jason

config :ex_aws,
  s3: [
    scheme: "https://",
    # Note You must specify the region in the host s3.{region}.amazonaws.com
    host: "polymorphic-productions.s3.us-west-2.amazonaws.com",
    # Note even though you have specified host to include the
    # region you still have to set it in the config. :(
    region: "us-west-2"
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
