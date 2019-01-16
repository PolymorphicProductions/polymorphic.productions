defmodule PolymorphicProductions.Messages.PushSubscriber do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "push_subscriber" do
    field(:auth, :string)
    field(:endpoint, :string)
    field(:p256dh, :string)
    field(:keys, {:map, :string}, virtual: true)

    timestamps()
  end

  @doc false
  def changeset(push_subscriber, attrs) do
    push_subscriber
    |> cast(attrs, [:endpoint, :keys])
    |> put_keys()
    |> validate_required([:endpoint, :p256dh, :auth])
  end

  def put_keys(
        %Ecto.Changeset{valid?: true, changes: %{keys: %{"p256dh" => p256dh, "auth" => auth}}} =
          cs
      ) do
    cs
    |> put_change(:p256dh, p256dh)
    |> put_change(:auth, auth)
  end
end
