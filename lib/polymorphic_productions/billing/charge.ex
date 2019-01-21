defmodule PolymorphicProductions.Billing.Charge do
  use Ecto.Schema
  import Ecto.Changeset
  alias PolymorphicProductions.Account.User

  schema "charges" do
    field(:stripe_id, :string)

    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(charge, attrs) do
    charge
    |> cast(attrs, [:stripe_id])
    |> validate_required([:stripe_id])
  end

  defp put_user(changeset, %{"user" => user}), do: put_assoc(changeset, :user, user)
  defp put_user(changeset, _), do: changeset
end
