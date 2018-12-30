defmodule PolymorphicProductions.Repo do
  alias PolymorphicProductions.Sessions.Session

  use Ecto.Repo,
    otp_app: :polymorphic_productions,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query

  use Kerosene, per_page: 10

  def approved(query) do
    from(q in query, where: q.approved == true)
  end

  def order_by_oldest(query) do
    from(q in query, order_by: [asc: q.inserted_at])
  end
end
