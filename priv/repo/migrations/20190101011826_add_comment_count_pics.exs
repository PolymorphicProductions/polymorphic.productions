defmodule PolymorphicProductions.Repo.Migrations.AddCommentCountPics do
  use Ecto.Migration

  def change do
    alter table("pics") do
      add(:comment_count, :integer, default: 0)
    end
  end
end
