defmodule PolymorphicProductions.Messages do
  alias PolymorphicProductions.Messages.Contact

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
end
