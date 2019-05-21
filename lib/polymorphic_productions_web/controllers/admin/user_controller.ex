defmodule PolymorphicProductionsWeb.Admin.UserController do
  use PolymorphicProductionsWeb, :controller

  alias PolymorphicProductions.{Accounts}

  @spec action(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns])
  end

  @spec index(Plug.Conn.t(), any(), %{current_user: any()}) :: {:error, any()} | Plug.Conn.t()
  def index(conn, _params, %{current_user: current_user}) do
    with :ok <- Bodyguard.permit(Accounts, :index, current_user, nil) do
      users = Accounts.list_users()
      render(conn, "index.html", users: users)
    end
  end

  @spec show(Plug.Conn.t(), map(), %{current_user: any()}) :: {:error, any()} | Plug.Conn.t()
  def show(conn, %{"id" => id}, %{current_user: current_user}) do
    with :ok <- Bodyguard.permit(Accounts, :show, current_user, nil) do
      user = Accounts.get_user(id)
      render(conn, "show.html", user: user)
    end
  end

  @spec edit(Plug.Conn.t(), map(), %{current_user: any()}) ::
          {:error, any()} | Plug.Conn.t()
  def edit(conn, %{"id" => id}, %{current_user: current_user}) do
    with :ok <- Bodyguard.permit(Accounts, :edit, current_user, nil) do
      user = Accounts.get_user(id)
      changeset = Accounts.admin_change_user(user)
      render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  @spec update(Plug.Conn.t(), map(), %{current_user: any()}) :: {:error, any()} | Plug.Conn.t()
  def update(conn, %{"id" => id, "user" => user_params}, %{current_user: current_user}) do
    with :ok <- Bodyguard.permit(Accounts, :update, current_user, nil) do
      user = Accounts.get_user!(id)

      case Accounts.admin_update_user(user, user_params) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "User updated successfully.")
          |> redirect(to: Routes.admin_user_path(conn, :show, user))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", user: user, changeset: changeset)
      end
    end
  end

  @spec delete(Plug.Conn.t(), map(), %{current_user: any()}) :: {:error, any()} | Plug.Conn.t()
  def delete(conn, %{"id" => id}, %{current_user: current_user}) do
    with :ok <- Bodyguard.permit(Accounts, :delete, current_user, nil) do
      user = Accounts.get_user!(id)

      {:ok, _user} = Accounts.delete_user(user)

      conn
      |> put_flash(:info, "User deleted successfully.")
      |> redirect(to: Routes.admin_user_path(conn, :index))
    end
  end
end
