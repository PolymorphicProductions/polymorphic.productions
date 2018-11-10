defmodule PolymorphicProductionsWeb.CommentController do
  use PolymorphicProductionsWeb, :controller

  import PolymorphicProductionsWeb.Authorize

  alias PolymorphicProductions.Social
  alias PolymorphicProductions.Social.Pix
  alias PolymorphicProductions.Social.Comment
  alias PolymorphicProductionsWeb.PixView

  # plug(:admin_check when action in [:new, :edit, :update, :delete])
  plug(:id_check when action in [:update, :delete])
  plug(:user_check when action in [:create])

  def create(conn, %{"pix_id" => pix_id}) do
    # case Social.create_pix(pix_params) do
    #   {:ok, pix} ->
    #     conn
    #     |> put_flash(:info, "Pix created successfully.")
    #     |> redirect(to: Routes.pix_path(conn, :show, pix))

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, "new.html", changeset: changeset)
    # end

    pix = Social.get_pix!(pix_id)

    conn
    |> put_flash(:info, "Pix updated successfully.")
    |> redirect(to: Routes.pix_path(conn, :show, pix))
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
