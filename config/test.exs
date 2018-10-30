use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :polymorphic_productions, PolymorphicProductionsWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :polymorphic_productions, PolymorphicProductions.Repo,
  username: "postgres",
  password: "postgres",
  database: "polymorphic_productions_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
