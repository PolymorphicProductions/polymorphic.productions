defmodule PolymorphicProductions.Social do
  defdelegate authorize(action, user, params), to: PolymorphicProductions.Social.Policy

  @moduledoc """
  The Social context.
  """

  import Ecto.Query, warn: false
  alias PolymorphicProductions.Repo

  alias PolymorphicProductions.Social.Pix
  alias PolymorphicProductions.Social.Comment

  @doc """
  Returns the list of pics.

  ## Examples

      iex> list_pics()
      [%Pix{}, ...]

  """
  def list_pics(params \\ %{}) do
    Pix
    |> from(order_by: [desc: :inserted_at])
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single pix.

  Raises `Ecto.NoResultsError` if the Pix does not exist.

  ## Examples

      iex> get_pix!(123)
      %Pix{}

      iex> get_pix!(456)
      ** (Ecto.NoResultsError)

  """
  @get_pix_defaults %{preload: []}
  def get_pix!(id, options \\ []) do
    %{preload: preload} = Enum.into(options, @get_pix_defaults)

    from(p in Pix,
      where: p.id == ^id,
      preload: ^preload
    )
    |> Repo.one!()
  end

  @doc """
  Creates a pix.

  ## Examples

      iex> create_pix(%{field: value})
      {:ok, %Pix{}}

      iex> create_pix(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pix(attrs \\ %{}) do
    %Pix{}
    |> Pix.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pix.

  ## Examples

      iex> update_pix(pix, %{field: new_value})
      {:ok, %Pix{}}

      iex> update_pix(pix, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pix(%Pix{} = pix, attrs) do
    pix
    |> Pix.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Pix.

  ## Examples

      iex> delete_pix(pix)
      {:ok, %Pix{}}

      iex> delete_pix(pix)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pix(%Pix{} = pix) do
    Repo.delete(pix)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pix changes.

  ## Examples

      iex> change_pix(pix)
      %Ecto.Changeset{source: %Pix{}}

  """
  def change_pix(%Pix{} = pix) do
    Pix.changeset(pix, %{})
  end

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id),
    do: from(c in Comment, preload: [:user, :pix]) |> Repo.get!(id)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{source: %Comment{}}

  """
  def change_comment(%Comment{} = comment) do
    Comment.changeset(comment, %{})
  end
end
