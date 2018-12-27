defmodule PolymorphicProductions.Repo.Migrations.AddSocialTags do
  use Ecto.Migration

  def change do
    rename(table(:comments), :pix_id, to: :pic_id)

    create table(:tags) do
      add(:name, :text, null: false)
    end

    create(index(:tags, ["lower(name)"], unique: true))

    create table(:pic_tags) do
      add(:tag_id, references(:tags))
      add(:pic_id, references(:pics, on_delete: :nothing, type: :uuid))
    end

    create(index(:pic_tags, [:tag_id, :pic_id], unique: true))
  end
end
