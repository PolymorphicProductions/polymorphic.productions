defmodule PolymorphicProductions.Repo do
  use Ecto.Repo,
    otp_app: :polymorphic_productions,
    adapter: Ecto.Adapters.Postgres

  use Kerosene, per_page: 2, next_label: ">>", previous_label: "<<"
end
