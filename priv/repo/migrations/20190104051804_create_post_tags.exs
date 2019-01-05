defmodule PolymorphicProductions.Repo.Migrations.CreatePostTags do
  use Ecto.Migration

  def change do
    create table(:post_tags) do
      add(:tag_id, references(:tags))
      add(:post_id, references(:posts, on_delete: :nothing))
    end

    create(index(:post_tags, [:tag_id, :post_id], unique: true))

    alter table(:posts) do
      add(:tags_string, :string)
    end
  end
end
