defmodule PolymorphicProductions.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add(:author, :string)
      add(:body, :text)
      add(:approved, :boolean, default: false, null: false)
      add(:pix_id, references(:pics, on_delete: :nothing, type: :uuid)))

      timestamps()
    end

    create(index(:comments, [:pix_id]))
  end
end
