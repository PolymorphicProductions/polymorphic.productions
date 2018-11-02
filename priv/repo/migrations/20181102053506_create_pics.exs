defmodule PolymorphicProductions.Repo.Migrations.CreatePics do
  use Ecto.Migration

  def change do
    create table(:pics, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:description, :text)
      add(:asset, :string)
      timestamps()
    end
  end
end
