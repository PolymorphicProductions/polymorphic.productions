defmodule PolymorphicProductions.Social do
  @moduledoc """
  The Social context.
  """

  import Ecto.Query, warn: false
  alias PolymorphicProductions.Repo

  alias PolymorphicProductions.Social.Pix

  @doc """
  Returns the list of pics.

  ## Examples

      iex> list_pics()
      [%Pix{}, ...]

  """
  def list_pics do
    Pix
    |> from(order_by: [desc: :inserted_at])
    |> Repo.all()
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
  def get_pix!(id), do: Repo.get!(Pix, id)

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
end
