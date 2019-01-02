defmodule PolymorphicProductionsWeb.CommentController do
  use PolymorphicProductionsWeb, :controller

  import PolymorphicProductionsWeb.Authenticate
  plug(:authentication_check when action in [:create])

  alias PolymorphicProductions.Social

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns])
  end

  def show(conn, %{"id" => id}, _) do
    %{pic: pic} = Social.get_comment!(id)

    conn
    |> redirect(to: Routes.pic_path(conn, :show, pic) <> "##{id}")
  end

  def create(conn, %{"pic_id" => pic_id, "comment" => comment_params}, %{
        current_user: current_user
      }) do
    pic = Social.get_pic!(pic_id)

    case comment_params
         |> Map.merge(%{"author" => current_user, "pic" => pic})
         |> Social.create_comment() do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment submitted.")
        |> redirect(to: Routes.pic_path(conn, :show, pic) <> "#foo")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"post_slug" => post_slug, "comment" => comment_params}, %{
        current_user: current_user
      }) do
    post = Social.get_post!(post_slug)

    case comment_params
         |> Map.merge(%{"author" => current_user, "post" => post})
         |> Social.create_comment() do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment submitted.")
        |> redirect(to: Routes.post_path(conn, :show, post) <> "#comments")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
