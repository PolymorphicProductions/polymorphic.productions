defmodule PolymorphicProductions.Messages do
  alias PolymorphicProductions.Messages.Contact
  alias PolymorphicProductions.Repo

  @doc """
  Creates a contact message and sends it.
  """
  def create_contact(attrs \\ %{}) do
    changeset = Contact.changeset(%Contact{}, attrs)

    case Ecto.Changeset.apply_action(changeset, :insert) do
      {:ok, contact} ->
        {:ok, contact}

      {:error, contact} ->
        {:error, contact}
    end
  end

  def change_contact(%Contact{} = contact) do
    Contact.changeset(contact, %{})
  end

  alias PolymorphicProductions.Messages.PushSubscriber

  @doc """
  Returns the list of push_subscriber.

  ## Examples

      iex> list_push_subscriber()
      [%PushSubscriber{}, ...]

  """
  def list_push_subscriber do
    Repo.all(PushSubscriber)
  end

  @doc """
  Gets a single push_subscriber.

  Raises `Ecto.NoResultsError` if the Push subscriber does not exist.

  ## Examples

      iex> get_push_subscriber!(123)
      %PushSubscriber{}

      iex> get_push_subscriber!(456)
      ** (Ecto.NoResultsError)

  """
  def get_push_subscriber!(id), do: Repo.get!(PushSubscriber, id)

  @doc """
  Creates a push_subscriber.

  ## Examples

      iex> create_push_subscriber(%{field: value})
      {:ok, %PushSubscriber{}}

      iex> create_push_subscriber(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_push_subscriber(%{"endpoint" => endpoint} = attrs) do
    case Repo.get_by(PushSubscriber, endpoint: endpoint) do
      %PushSubscriber{} = ps ->
        {:ok, ps}

      _ ->
        %PushSubscriber{}
        |> PushSubscriber.changeset(attrs)
        |> Repo.insert()
    end
  end

  @doc """
  Updates a push_subscriber.

  ## Examples

      iex> update_push_subscriber(push_subscriber, %{field: new_value})
      {:ok, %PushSubscriber{}}

      iex> update_push_subscriber(push_subscriber, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def update_push_subscriber(%PushSubscriber{} = push_subscriber, attrs) do
    push_subscriber
    |> PushSubscriber.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PushSubscriber.

  ## Examples

      iex> delete_push_subscriber(push_subscriber)
      {:ok, %PushSubscriber{}}

      iex> delete_push_subscriber(push_subscriber)
      {:error, %Ecto.Changeset{}}

  """
  def delete_push_subscriber(%PushSubscriber{} = push_subscriber) do
    Repo.delete(push_subscriber)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking push_subscriber changes.

  ## Examples

      iex> change_push_subscriber(push_subscriber)
      %Ecto.Changeset{source: %PushSubscriber{}}

  """
  def change_push_subscriber(%PushSubscriber{} = push_subscriber) do
    PushSubscriber.changeset(push_subscriber, %{})
  end
end
