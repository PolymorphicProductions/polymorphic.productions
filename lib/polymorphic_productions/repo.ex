defmodule PolymorphicProductions.Repo do
  use Ecto.Repo,
    otp_app: :polymorphic_productions,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query

  use Kerosene, per_page: 10

  def order_by_inserted_at(query, direction \\ :asc) when direction in [:asc, :desc] do
    from(q in query, order_by: [{^direction, :inserted_at}])
  end

  def order_by_published_at(query, direction \\ :asc) when direction in [:asc, :desc] do
    from(q in query, order_by: [{^direction, :published_at}])
  end

  def by_slug(query, slug), do: from(q in query, where: q.slug == ^slug)

  def by_uuid(query, uuid), do: from(q in query, where: q.id == ^uuid)

  def published(query), do: from(q in query, where: q.published_at <= ^Timex.today())

  def approved(query), do: from(q in query, where: q.approved == true)

  def not_approved(query), do: from(q in query, where: q.approved == false)

  def draft(query), do: from(q in query, where: q.draft == true)

  def not_draft(query), do: from(q in query, where: q.draft == false)
end
