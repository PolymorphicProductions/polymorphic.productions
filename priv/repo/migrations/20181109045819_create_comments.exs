defmodule PolymorphicProductions.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add(:name, :string)
      add(:body, :text)
      add(:approved, :boolean, default: false, null: false)
      add(:pix_id, references(:pics, on_delete: :nothing, type: :uuid))
      add(:author_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    create(index(:comments, [:pix_id]))
    create(index(:comments, [:author_id]))
  end
end
