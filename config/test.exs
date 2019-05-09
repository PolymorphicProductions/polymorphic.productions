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
  port: System.get_env("PP_REPO_TEST_PORT") || 5432,
  pool: Ecto.Adapters.SQL.Sandbox

# Comeonin password hashing test config
config :argon2_elixir, t_cost: 2, m_cost: 8

config :phoenix, :plug_init_mode, :runtime

config :phauxth, log_level: :error
# config :pbkdf2_elixir, rounds: 1

# Mailer test configuration
config :polymorphic_productions, PolymorphicProductions.Mailer, adapter: Bamboo.TestAdapter

config :polymorphic_productions,
  render_tracking: false,
  asset_uploader: PolymorphicProductions.Mocks.Uploader,
  asset_processor: PolymorphicProductions.Mocks.Processor
