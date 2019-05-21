defmodule PolymorphicProductionsWeb.PicController do
  use PolymorphicProductionsWeb, :controller

  alias PolymorphicProductions.Social
  alias PolymorphicProductions.Social.{Pic, Comment}
  alias PolymorphicProductions.Repo

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns])
  end

  @spec index(Plug.Conn.t(), map(), any()) :: Plug.Conn.t()
  def index(conn, params, _) do
    {pics, kerosene} = Social.list_pics(params)
    render(conn, "index.html", pics: pics, kerosene: kerosene)
  end

  @spec new(Plug.Conn.t(), any(), %{current_user: any()}) :: Plug.Conn.t()
  def new(conn, _params, %{current_user: current_user}) do
    with :ok <- Bodyguard.permit(Social, :create_pic, current_user, nil),
         changeset = Social.change_pic(%Pic{}) do
      render(conn, "new.html", changeset: changeset)
    end
  end

  @spec create(Plug.Conn.t(), map(), %{current_user: any()}) :: Plug.Conn.t()
  def create(conn, %{"pic" => pic_params}, %{current_user: current_user}) do
    with :ok <- Bodyguard.permit(Social, :create, current_user, nil) do
      case Social.create_pic(pic_params) do
        {:ok, pic} ->
          conn
          |> put_flash(:info, "Pic created successfully.")
          |> redirect(to: Routes.pic_path(conn, :show, pic))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end

  @spec show(Plug.Conn.t(), map(), any()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}, _) do
    changeset = Social.change_comment(%Comment{})

    pic =
      Social.get_pic!(id,
        preload: [
          :tags,
          comments: {Comment |> Repo.approved() |> Repo.order_by_oldest(), :user}
        ]
      )

    render(conn, "show.html", pic: pic, changeset: changeset)
  end

  @spec edit(Plug.Conn.t(), map(), %{current_user: any()}) :: Plug.Conn.t()
  def edit(conn, %{"id" => id}, %{current_user: current_user}) do
    with :ok <- Bodyguard.permit(Social, :edit, current_user, nil) do
      pic = Social.get_pic!(id, preload: [:tags])
      changeset = Social.change_pic(pic)
      render(conn, "edit.html", pic: pic, changeset: changeset)
    end
  end

  @spec update(Plug.Conn.t(), map(), %{current_user: any()}) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "pic" => pic_params}, %{current_user: current_user}) do
    with :ok <- Bodyguard.permit(Social, :update, current_user, nil) do
      pic = Social.get_pic!(id, preload: [:tags])

      case Social.update_pic(pic, pic_params) do
        {:ok, pic} ->
          conn
          |> put_flash(:info, "Pic updated successfully.")
          |> redirect(to: Routes.pic_path(conn, :show, pic))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", pic: pic, changeset: changeset)
      end
    end
  end

  @spec delete(Plug.Conn.t(), map(), %{current_user: any()}) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}, %{current_user: current_user}) do
    with :ok <- Bodyguard.permit(Social, :delete, current_user, nil) do
      pic = Social.get_pic!(id, preload: [:tags])
      {:ok, _pic} = Social.delete_pic(pic)

      conn
      |> put_flash(:info, "Pic deleted successfully.")
      |> redirect(to: Routes.pic_path(conn, :index))
    end
  end
end
