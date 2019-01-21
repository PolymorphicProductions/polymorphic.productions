defmodule PolymorphicProductions.Billing.Charge do
  use Ecto.Schema
  import Ecto.Changeset
  alias PolymorphicProductions.Account.User

  schema "charges" do
    field(:strip_id, :string)

    # belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(charge, attrs) do
    charge
    |> cast(attrs, [:strip_id])
    |> validate_required([:strip_id])
  end
end
