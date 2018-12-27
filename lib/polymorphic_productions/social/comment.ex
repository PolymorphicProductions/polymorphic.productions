defmodule PolymorphicProductions.Social.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias PolymorphicProductions.Social.Pic
  alias PolymorphicProductions.Accounts.User

  schema "comments" do
    field(:approved, :boolean, default: false)
    field(:body, :string)
    belongs_to(:pic, Pic, type: :binary_id)
    belongs_to(:user, User, foreign_key: :author_id)

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :approved])
    |> validate_required([:body, :approved])
    |> put_pic(attrs)
    |> put_author(attrs)
    |> put_approved(attrs)
  end

  defp put_author(changeset, %{"author" => author}), do: put_assoc(changeset, :user, author)
  defp put_author(changeset, _), do: changeset

  defp put_pic(changeset, %{"pic" => pic}), do: put_assoc(changeset, :pic, pic)
  defp put_pic(changeset, _), do: changeset

  defp put_approved(changeset, %{"author" => _author}), do: put_change(changeset, :approved, true)
  defp put_approved(changeset, _), do: changeset
end
