defmodule PolymorphicProductionsWeb.CommentController do
  use PolymorphicProductionsWeb, :controller

  import PolymorphicProductionsWeb.Authenticate
  plug(:authentication_check when action in [:create])

  alias PolymorphicProductions.Social

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns])
  end

  def show(conn, %{"id" => id}, _) do
    %{pix: pix} = Social.get_comment!(id)

    conn
    |> redirect(to: Routes.pix_path(conn, :show, pix) <> "##{id}")
  end

  def create(conn, %{"pix_id" => pix_id, "comment" => comment_params}, %{
        current_user: current_user
      }) do
    pix = Social.get_pix!(pix_id)

    case comment_params
         |> Map.merge(%{"author" => current_user, "pix" => pix})
         |> Social.create_comment() do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment submitted.")
        |> redirect(to: Routes.pix_path(conn, :show, pix) <> "#foo")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
