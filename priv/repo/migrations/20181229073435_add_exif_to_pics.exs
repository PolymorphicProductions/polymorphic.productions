defmodule PolymorphicProductions.Repo.Migrations.AddExifToPics do
  use Ecto.Migration

  def change do
    alter table(:pics) do
      add(:meta, :map)
    end
  end
end
