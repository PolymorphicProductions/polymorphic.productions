defmodule PolymorphicProductions.Social.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias PolymorphicProductions.Social.{Pic, Post}
  alias PolymorphicProductions.Accounts.User

  schema "comments" do
    field(:approved, :boolean, default: false)
    field(:body, :string)
    belongs_to(:pic, Pic, type: :binary_id)
    belongs_to(:post, Post)

    belongs_to(:user, User, foreign_key: :author_id)

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :approved])
    |> validate_required([:body, :approved])
    |> put_pic(attrs)
    |> put_post(attrs)
    |> put_author(attrs)
    |> put_approved(attrs)
    |> increment_comment_count(attrs)
  end

  defp put_author(changeset, %{"author" => author}), do: put_assoc(changeset, :user, author)
  defp put_author(changeset, _), do: changeset

  defp put_pic(changeset, %{"pic" => pic}), do: put_assoc(changeset, :pic, pic)
  defp put_pic(changeset, _), do: changeset

  defp put_post(changeset, %{"post" => post}),
    do: put_assoc(changeset, :post, post) |> IO.inspect()

  defp put_post(changeset, _), do: changeset

  defp put_approved(changeset, %{"author" => _author}), do: put_change(changeset, :approved, true)
  defp put_approved(changeset, _), do: changeset

  defp increment_comment_count(changeset, %{"pic" => _pic}) do
    changeset
    |> prepare_changes(fn changeset ->
      if %{data: %{id: id}} = get_change(changeset, :pic) do
        query = from(p in Pic, where: p.id == ^id)
        changeset.repo.update_all(query, inc: [comment_count: 1])
      end

      changeset
    end)
  end

  defp increment_comment_count(changeset, %{"post" => _post}) do
    changeset
    |> prepare_changes(fn changeset ->
      if %{data: %{slug: slug}} = get_change(changeset, :post) do
        query = from(p in Post, where: p.slug == ^slug)
        changeset.repo.update_all(query, inc: [comment_count: 1])
      end

      changeset
    end)
  end

  defp increment_comment_count(changeset, _), do: changeset
end
