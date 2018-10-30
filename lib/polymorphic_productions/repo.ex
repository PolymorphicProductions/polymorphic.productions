defmodule PolymorphicProductions.Repo do
  use Ecto.Repo,
    otp_app: :polymorphic_productions,
    adapter: Ecto.Adapters.Postgres
end
