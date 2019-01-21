defmodule PolymorphicProductions.Repo.Migrations.CreateCharges do
  use Ecto.Migration

  def change do
    create table(:charges) do
      add(:stripe_id, :string)
      add(:user, references(:users, on_delete: :nothing))

      timestamps()
    end
  end
end
