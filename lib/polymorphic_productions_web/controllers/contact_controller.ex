defmodule PolymorphicProductionsWeb.ContactController do
  use PolymorphicProductionsWeb, :controller
  alias PolymorphicProductions.{Messages, Messages.Contact}
  alias PolymorphicProductionsWeb.Email

  def new(conn, _) do
    changeset = Messages.change_contact(%Contact{})

    conn
    |> assign(:nav_class, "navbar navbar-absolute navbar-fixed")
    |> render("new.html",
      layout: {PolymorphicProductionsWeb.LayoutView, "full-header.html"},
      changeset: changeset
    )
  end

  def create(conn, %{"contact" => contact_params}) do
    case Messages.create_contact(contact_params) do
      {:ok, contact} ->
        Email.contact_request(conn, contact)

        conn
        |> put_flash(:info, "Your messages was successfully sent.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          layout: {PolymorphicProductionsWeb.LayoutView, "full-header.html"},
          changeset: changeset
        )
    end
  end
end
