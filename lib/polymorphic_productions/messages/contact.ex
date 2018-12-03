defmodule PolymorphicProductions.Messages.Contact do
  use Ecto.Schema

  import Ecto.Changeset

  @mail_regex ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/

  embedded_schema do
    field(:name, :string)
    field(:email, :string)
    field(:subject, :string)
    field(:message, :string)
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:name, :email, :subject, :message])
    |> validate_required([:name, :email, :subject, :message])
    |> validate_format(:email, @mail_regex, message: "Not a valid email")
  end
end
