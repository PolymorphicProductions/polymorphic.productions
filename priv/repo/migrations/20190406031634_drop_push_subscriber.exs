defmodule PolymorphicProductions.Repo.Migrations.DropPushSubscriber do
  use Ecto.Migration

  def change do
    drop(table(:push_subscriber))
  end
end
