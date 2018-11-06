defmodule PolymorphicProductions.Repo do
  use Ecto.Repo,
    otp_app: :polymorphic_productions,
    adapter: Ecto.Adapters.Postgres

  use Kerosene, per_page: 10
end
