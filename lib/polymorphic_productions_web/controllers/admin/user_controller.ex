defmodule PolymorphicProductionsWeb.Admin.UserController do
  use PolymorphicProductionsWeb, :controller

  import PolymorphicProductionsWeb.Authenticate
  plug(:authentication_check)

  alias PolymorphicProductions.{Accounts}

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns])
  end

  def index(conn, _params, %{current_user: current_user}) do
    with :ok <- Bodyguard.permit(Accounts, :index, current_user, nil) do
      users = Accounts.list_users()
      render(conn, "index.html", users: users)
    end
  end

  def show(conn, %{"id" => id}, %{current_user: current_user}) do
    with :ok <- Bodyguard.permit(Accounts, :show, current_user, nil) do
      user = Accounts.get_user(id)
      render(conn, "show.html", user: user)
    end
  end

  def edit(conn, %{"id" => id}, %{current_user: current_user}) do
    with :ok <- Bodyguard.permit(Accounts, :edit, current_user, nil) do
      user = Accounts.get_user(id)
      changeset = Accounts.change_user(user)
      render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}, %{current_user: current_user}) do
    with :ok <- Bodyguard.permit(Accounts, :update, current_user, nil) do
      user = Accounts.get_user!(id)

      case Accounts.update_user(user, user_params) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "User updated successfully.")
          |> redirect(to: Routes.user_path(conn, :show, user))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", user: user, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}, %{current_user: current_user}) do
    with :ok <- Bodyguard.permit(Accounts, :delete, current_user, nil) do
      user = Accounts.get_user!(id)

      {:ok, _user} = Accounts.delete_user(user)

      conn
      |> put_flash(:info, "User deleted successfully.")
      |> redirect(to: Routes.session_path(conn, :new))
    end
  end
end
