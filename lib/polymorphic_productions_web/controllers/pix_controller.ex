defmodule PolymorphicProductionsWeb.PixController do
  use PolymorphicProductionsWeb, :controller

  import PolymorphicProductionsWeb.Authenticate
  plug(:authentication_check when action in [:new, :create])

  import Ecto.Query

  alias PolymorphicProductions.Social
  alias PolymorphicProductions.Social.{Pix, Comment}
  alias PolymorphicProductions.Repo

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns])
  end

  def index(conn, params, _) do
    {pics, kerosene} = Social.list_pics(params)
    render(conn, "index.html", pics: pics, kerosene: kerosene)
  end

  def new(conn, _params, %{current_user: current_user}) do
    with :ok <- Bodyguard.permit(Social, :create_pix, current_user, nil),
         changeset = Social.change_pix(%Pix{}) do
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"pix" => pix_params}, %{current_user: current_user}) do
    with :ok <- Bodyguard.permit(Social, :create, current_user, nil) do
      case Social.create_pix(pix_params) do
        {:ok, pix} ->
          conn
          |> put_flash(:info, "Pix created successfully.")
          |> redirect(to: Routes.pix_path(conn, :show, pix))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end

  def show(conn, %{"id" => id}, _) do
    changeset = Social.change_comment(%Comment{})

    pix =
      Social.get_pix!(id,
        preload: [
          comments: {Comment |> Repo.approved() |> Repo.order_by_oldest(), :user}
        ]
      )

    render(conn, "show.html", pix: pix, changeset: changeset)
  end

  def edit(conn, %{"id" => id}, %{current_user: current_user}) do
    with :ok <- Bodyguard.permit(Social, :edit, current_user, nil) do
      pix = Social.get_pix!(id)
      changeset = Social.change_pix(pix)
      render(conn, "edit.html", pix: pix, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "pix" => pix_params}, %{current_user: current_user}) do
    with :ok <- Bodyguard.permit(Social, :update, current_user, nil) do
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
  end

  def delete(conn, %{"id" => id}, %{current_user: current_user}) do
    with :ok <- Bodyguard.permit(Social, :delete, current_user, nil) do
      pix = Social.get_pix!(id)
      {:ok, _pix} = Social.delete_pix(pix)

      conn
      |> put_flash(:info, "Pix deleted successfully.")
      |> redirect(to: Routes.pix_path(conn, :index))
    end
  end
end
