defmodule PolymorphicProductions.Repo.Migrations.AddInfoToPix do
  use Ecto.Migration

  def change do
    alter table(:pics) do
      add(:asset_preview_height, :integer)
      add(:asset_preview_width, :integer)
    end
  end
end
