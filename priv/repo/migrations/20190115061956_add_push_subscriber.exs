defmodule PolymorphicProductions.Repo.Migrations.AddPushSubscriber do
  use Ecto.Migration

  def change do
    create table(:push_subscriber, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:endpoint, :string)
      add(:p256dh, :string)
      add(:auth, :string)
      timestamps()
    end
  end
end
