defmodule PolymorphicProductions.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add(:title, :string, null: false)
      add(:slug, :string, null: false)
      add(:excerpt, :text, null: false)
      add(:body, :text, null: false)
      add(:published_at, :date)

      add(:image, :string)
      add(:large_image, :string)
      add(:med_image, :string)
      add(:comment_count, :integer, default: 0)

      timestamps()
    end

    alter table(:comments) do
      add(:post_id, references(:posts, on_delete: :delete_all))
      add(:comment_count, :integer, default: 0)
    end

    create(index(:comments, [:post_id]))
    create(unique_index(:posts, [:slug]))
  end
end
