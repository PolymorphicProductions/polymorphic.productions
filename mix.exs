defmodule PolymorphicProductions.MixProject do
  use Mix.Project

  def project do
    [
      app: :polymorphic_productions,
      version: "1.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls.html": :test]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {PolymorphicProductions.Application, []},
      extra_applications: [:sitemap, :inets, :ex_machina, :sentry, :logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.0"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:phauxth, "~> 2.0.0"},
      {:bodyguard, "~> 2.2"},
      {:bcrypt_elixir, "~> 1.0"},
      {:bamboo, "~> 1.1"},
      {:edeliver, ">= 1.6.0"},
      {:distillery, "~> 2.0", warn_missing: false},
      {:argon2_elixir, "~> 1.3"},
      {:mogrify, "~> 0.6.1"},
      {:ex_aws, "~> 2.0"},
      {:ex_aws_s3, "~> 2.0"},
      {:hackney, "~> 1.9"},
      {:sweet_xml, "~> 0.6"},
      {:uuid, "~> 1.1"},
      {:timex, "~> 3.1"},
      {:sentry, "~> 7.0"},
      {:kerosene, github: "PolymorphicProductions/kerosene"},
      {:social_parser, "~> 2.0"},
      {:excoveralls, "~> 0.10.2"},
      {:ex_machina, "~> 2.2"},
      {:exexif, "~> 0.0.5"},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:sitemap, "~> 1.1"},
      {:slugify, "~> 1.1"},
      {:earmark, "~> 1.3"},
      {:cors_plug, "~> 1.5"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
