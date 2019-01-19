defmodule PolymorphicProductions.Repo.Migrations.AddPublishedAtLocalToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add(:published_at_local, :string)
      add(:draft, :boolean, default: false, null: false)
    end
  end
end
