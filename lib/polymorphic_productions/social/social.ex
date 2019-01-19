defmodule PolymorphicProductions.Social do
  defdelegate authorize(action, user, params), to: PolymorphicProductions.Social.Policy

  @moduledoc """
  The Social context.
  """

  import Ecto.Query, warn: false
  alias PolymorphicProductions.Repo

  alias PolymorphicProductions.Social.{Pic, Comment, Tag, Post}

  alias PolymorphicProductions.Accounts.User

  @doc """
  Returns the list of pics.

  ## Examples

      iex> list_pics()
      [%Pic{}, ...]

  """
  def list_pics(params \\ %{}) do
    Pic
    |> from(order_by: [desc: :inserted_at])
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single pic.

  Raises `Ecto.NoResultsError` if the Pic does not exist.

  ## Examples

      iex> get_pic!(123)
      %Pic{}

      iex> get_pic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pic!(uuid, options \\ []) do
    preload = Keyword.get(options, :preload, [])

    Pic
    |> Repo.by_uuid(uuid)
    |> from(preload: ^preload)
    |> Repo.one!()
  end

  @doc """
  Creates a pic.

  ## Examples

      iex> create_pic(%{field: value})
      {:ok, %Pic{}}

      iex> create_pic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pic(attrs \\ %{}) do
    %Pic{}
    |> Pic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pic.

  ## Examples

      iex> update_pic(pic, %{field: new_value})
      {:ok, %Pic{}}

      iex> update_pic(pic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pic(%Pic{} = pic, attrs) do
    pic
    |> Pic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Pic.

  ## Examples

      iex> delete_pic(pic)
      {:ok, %Pic{}}

      iex> delete_pic(pic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pic(%Pic{} = pic) do
    Repo.delete(pic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pic changes.

  ## Examples

      iex> change_pic(pic)
      %Ecto.Changeset{source: %Pic{}}

  """
  def change_pic(%Pic{} = pic) do
    Pic.changeset(pic, %{})
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
    do: from(c in Comment, preload: [:user, :pic]) |> Repo.get!(id)

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

  def tags_preload do
    :tags
  end

  def approved_comments_preload do
    {:comments, {Comment |> Repo.approved() |> Repo.order_by_oldest(), :user}}
  end

  @doc """
  Gets a single tag and all of its pics.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag_by_slug!(foobar)
      %Tag{ pics: [...] }

      iex> get_comment!(badtag)
      ** (Ecto.NoResultsError)

  """
  def get_tag!(tag, params \\ %{}) do
    down_tag = String.downcase(tag)

    total_count =
      from(t in "tags",
        join: pt in "pic_tags",
        on: pt.tag_id == t.id,
        where: t.name == ^down_tag,
        select: count()
      )
      |> Repo.one()

    {pics_query, k} =
      from(p in Pic, order_by: [desc: :inserted_at])
      |> Repo.paginate(params, total_count: total_count, lazy: true)

    tag =
      from(t in Tag, where: t.name == ^down_tag, preload: [pics: ^pics_query])
      |> Repo.one!()

    {tag, k}
  end

  def get_post_tag!(tag, params \\ %{}) do
    total_count =
      from(t in "tags",
        join: pt in "post_tags",
        on: pt.tag_id == t.id,
        where: t.name == ^tag,
        select: count()
      )
      |> Repo.one()

    {posts_query, k} =
      from(p in Post, order_by: [desc: :inserted_at])
      |> Repo.paginate(params, total_count: total_count, lazy: true)

    tag =
      from(t in Tag, where: t.name == ^tag, preload: [posts: ^posts_query])
      |> Repo.one!()

    {tag, k}
  end

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts(params, user) do
    Post
    |> from(order_by: [desc: :inserted_at], preload: [:tags])
    # <-- defers to MyApp.Blog.Post.scope/3
    |> Bodyguard.scope(user)
    |> Repo.order_by_published_at()
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!("foo")
      %Post{}

      iex> get_post!("bar")
      ** (Ecto.NoResultsError)

  """

  def get_post!(slug, current_user, options \\ []) do
    preload = Keyword.get(options, :preload, [])

    Post
    |> Repo.by_slug(slug)
    |> from(preload: ^preload)
    |> Bodyguard.scope(current_user)
    |> Repo.one!()
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end
end
