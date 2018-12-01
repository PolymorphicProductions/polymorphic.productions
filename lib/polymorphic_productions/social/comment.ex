defmodule PolymorphicProductions.Social.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias PolymorphicProductions.Social.Pix
  alias PolymorphicProductions.Accounts.User

  schema "comments" do
    field(:approved, :boolean, default: false)
    field(:body, :string)
    belongs_to(:pix, Pix, type: :binary_id)
    belongs_to(:user, User, foreign_key: :author_id)

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :approved])
    |> validate_required([:body, :approved])
    |> put_pix(attrs)
    |> put_approved(attrs)
  end

  defp put_pix(changeset, %{"pix" => pix}) do
    changeset
    |> put_assoc(:pix, pix)
  end

  defp put_pix(changeset, _), do: changeset

  defp put_approved(changeset, %{"author" => author}) do
    put_change(changeset, :approved, true)
  end

  defp put_approved(changeset, a) do
    changeset
  end
end
