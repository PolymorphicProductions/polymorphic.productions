defmodule PolymorphicProductionsWeb.CommentController do
  use PolymorphicProductionsWeb, :controller

  import PolymorphicProductionsWeb.Authorize

  alias PolymorphicProductions.Social

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns])
  end

  # plug(:admin_check when action in [:new, :edit, :update, :delete])
  plug(:id_check when action in [:update, :delete])
  plug(:user_check when action in [:create])

  def show(conn, %{"id" => id}, _) do
    %{pix: pix} = comment = Social.get_comment!(id)

    conn
    |> redirect(to: Routes.pix_path(conn, :show, pix) <> "##{id}")
  end

  def create(conn, %{"pix_id" => pix_id, "comment" => comment_params}, %{
        current_user: current_user
      }) do
    # TODO: 
    # combine pix, user and comment_params and call create_pix
    # handel reponse

    pix = Social.get_pix!(pix_id)

    case comment_params
         |> Map.merge(%{"author" => current_user, "pix" => pix})
         |> Social.create_comment() do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment submitted.")
        |> redirect(to: Routes.pix_path(conn, :show, pix) <> "#foo")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
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
