defmodule PolymorphicProductions.Accounts do
  @moduledoc """
  The Accounts context.
  """

  defdelegate authorize(action, user, params), to: PolymorphicProductions.Accounts.Policy

  alias PolymorphicProductions.Accounts.User

  import Ecto.Query, warn: false

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user by their email.
  returns nil if no user is found

  ## Examples

      iex> get_by(%{"email" => "some_valid_email@foo.bar"})
      %User{}

      iex> get_by(%{"email" => "bad_email@foo.bar"})
      nil
  """
  def get_by(%{"email" => email}) when is_bitstring(email), do: Repo.get_by(User, email: email)

  @doc """
  Gets a single user by their id.
  returns nil if no user is found

  ## Examples

      iex> get_by(%{"user_id" => 1})
      %User{}

      iex> get_by(%{"user_id" => 0})
      nil
  """

  def get_by(%{"user_id" => user_id}), do: Repo.get(User, user_id)

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user.

  return nil if no user is found
  ## Examples

      iex> get_user(123)
      %User{}

      iex> get_user!(456)
      nil

  """
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Creates a user.
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Confirms a user's email.
  """
  def confirm_user(%User{} = user) do
    user |> User.confirm_changeset() |> Repo.update()
  end

  @doc """
  Makes a password reset request.
  """
  def create_password_reset(attrs) do
    case get_by(attrs) do
      %PolymorphicProductions.Accounts.User{} = user ->
        user
        |> User.password_reset_changeset(DateTime.utc_now() |> DateTime.truncate(:second))
        |> Repo.update()

      _ ->
        {:error, "no user found"}
    end
  end
end
