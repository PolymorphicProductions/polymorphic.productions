defmodule PolymorphicProductions.Social.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias PolymorphicProductions.Social.Pix
  alias PolymorphicProductions.Accounts.User

  schema "comments" do
    field(:approved, :boolean, default: false)
    field(:author, :string)
    field(:body, :string)
    belongs_to(:pix, Pix, type: :binary_id)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:name, :body, :approved])
    |> validate_required([:name, :body, :approved])
  end
end
