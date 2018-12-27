defmodule PolymorphicProductions.Repo.Migrations.AddPreviewToPic do
  use Ecto.Migration

  def change do
    alter table(:pics) do
      add(:asset_preview, :string)
    end
  end
end
