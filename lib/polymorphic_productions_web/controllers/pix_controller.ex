defmodule PolymorphicProductionsWeb.PixController do
  use PolymorphicProductionsWeb, :controller

  import PolymorphicProductionsWeb.Authorize

  alias PolymorphicProductions.Social
  alias PolymorphicProductions.Social.Pix

  plug(:admin_check when action in [:new, :edit, :update, :delete])

  def index(conn, params) do
    {pics, kerosene} = Social.list_pics(params)

    render(conn, "index.html", pics: pics, kerosene: kerosene)
  end

  def new(conn, _params) do
    changeset = Social.change_pix(%Pix{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"pix" => pix_params}) do
    case Social.create_pix(pix_params) do
      {:ok, pix} ->
        conn
        |> put_flash(:info, "Pix created successfully.")
        |> redirect(to: Routes.pix_path(conn, :show, pix))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    pix = Social.get_pix!(id)
    render(conn, "show.html", pix: pix)
  end

  def edit(conn, %{"id" => id}) do
    pix = Social.get_pix!(id)
    changeset = Social.change_pix(pix)
    render(conn, "edit.html", pix: pix, changeset: changeset)
  end

  def update(conn, %{"id" => id, "pix" => pix_params}) do
    pix = Social.get_pix!(id)

    case Social.update_pix(pix, pix_params) do
      {:ok, pix} ->
        conn
        |> put_flash(:info, "Pix updated successfully.")
        |> redirect(to: Routes.pix_path(conn, :show, pix))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", pix: pix, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    pix = Social.get_pix!(id)
    {:ok, _pix} = Social.delete_pix(pix)

    conn
    |> put_flash(:info, "Pix deleted successfully.")
    |> redirect(to: Routes.pix_path(conn, :index))
  end
end
