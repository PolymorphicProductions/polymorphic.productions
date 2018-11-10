defmodule PolymorphicProductions.Social.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias PolymorphicProductions.Social.Pix

  schema "comments" do
    field(:approved, :boolean, default: false)
    field(:author, :string)
    field(:body, :string)
    belongs_to(:pix, Pix, type: :binary_id)

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:author, :body, :approved])
    |> validate_required([:author, :body, :approved])
  end
end
