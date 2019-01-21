defmodule PolymorphicProductions.Billing do
  @moduledoc """
  The Billing context.
  """

  import Ecto.Query, warn: false
  alias PolymorphicProductions.Repo

  alias PolymorphicProductions.Billing.Charge
  alias PolymorphicProductions.{Accounts}
  alias PolymorphicProductions.Accounts.{User}

  @doc """
  Returns the list of charges.

  ## Examples

      iex> list_charges()
      [%Charge{}, ...]

  """
  def list_charges do
    Repo.all(Charge)
  end

  @doc """
  Gets a single charge.

  Raises `Ecto.NoResultsError` if the Charge does not exist.

  ## Examples

      iex> get_charge!(123)
      %Charge{}

      iex> get_charge!(456)
      ** (Ecto.NoResultsError)

  """
  def get_charge!(id), do: Repo.get!(Charge, id)

  @doc """
  Creates a charge.

  ## Examples

      iex> create_charge(%{field: value})
      {:ok, %Charge{}}

      iex> create_charge(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  # TODO: 
  # - Find or invite/create user
  # - Find or create stripe customer and attach to user
  # - Find or create if needed stored payment
  # - create new stripe charge
  # -- handle failure
  # --- re render user charge page with errors.
  # --- log errors and notify 
  # -- handle successful charge
  # --- create new charge record 
  # --- send receipt confirmation
  # --- log and notify payment
  # --- TODO: Design how to abstract from different types of things that someone will pay for. 
  # --- IE unlocking a post vs paying an invoice vs unlocking digital goods. 
  def create_charge(_, attrs \\ %{})

  def create_charge(%User{} = current_user, attrs) do
    stripe_attrs = attrs |> stripe_charge_attr

    case Stripe.Charge.create(stripe_attrs) |> IO.inspect() do
      {:ok, charge} ->
        charge_attrs =
          attrs
          |> Map.merge("user", current_user)

        %Charge{}
        |> Charge.changeset(attrs)
        |> Repo.insert()

      _ ->
        {:error, "strip processing error"}
    end
  end

  def create_charge(_, attrs) do
    stripe_attrs = attrs |> stripe_charge_attr

    case Stripe.Charge.create(stripe_attrs) |> IO.inspect() do
      {:ok, charge} ->
        %Charge{}
        |> Charge.changeset(attrs)
        |> Repo.insert()
        |> IO.inspect()

      _ ->
        {:error, "strip processing error"}
    end
  end

  defp stripe_charge_attr(attrs) do
    %{
      "currency" => "usd",
      "metadata" => %{
        "post_id" => "xxxx"
      }
    }
    |> Map.merge(Map.take(attrs, ["source", "amount", "description"]))
  end

  @doc """
  Updates a charge.

  ## Examples

      iex> update_charge(charge, %{field: new_value})
      {:ok, %Charge{}}

      iex> update_charge(charge, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_charge(%Charge{} = charge, attrs) do
    charge
    |> Charge.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Charge.

  ## Examples

      iex> delete_charge(charge)
      {:ok, %Charge{}}

      iex> delete_charge(charge)
      {:error, %Ecto.Changeset{}}

  """
  def delete_charge(%Charge{} = charge) do
    Repo.delete(charge)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking charge changes.

  ## Examples

      iex> change_charge(charge)
      %Ecto.Changeset{source: %Charge{}}

  """
  def change_charge(%Charge{} = charge) do
    Charge.changeset(charge, %{})
  end
end
