defmodule PolymorphicProductionsWeb.UserController do
  use PolymorphicProductionsWeb, :controller

  import PolymorphicProductionsWeb.Authenticate
  plug(:authentication_check when action in [:show, :edit, :update])

  alias Phauxth.Log
  alias PolymorphicProductions.{Accounts, Accounts.User}
  alias PolymorphicProductionsWeb.{Auth.Token, Email}

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns])
  end

  def new(conn, _params, _) do
    changeset = Accounts.change_user(%User{})

    conn
    |> assign(:nav_class, "navbar navbar-absolute navbar-fixed")
    |> render("new.html",
      layout: {PolymorphicProductionsWeb.LayoutView, "full-header.html"},
      request_path: nil,
      changeset: changeset
    )
  end

  # TODO gate already signed in users
  def create(conn, %{"user" => user_params}, _) do
    case Accounts.create_user(user_params) do
      {:ok, %User{email: email} = user} ->
        Log.info(%Log{user: user.id, message: "user created"})
        key = Token.sign(%{"email" => email})
        Email.confirm_request(conn, user, key)

        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.session_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:nav_class, "navbar navbar-absolute navbar-fixed")
        |> render("new.html",
          layout: {PolymorphicProductionsWeb.LayoutView, "full-header.html"},
          changeset: changeset
        )
    end
  end

  def show(conn, _, %{current_user: current_user}) do
    render(conn, "show.html", user: current_user)
  end

  def edit(conn, _, %{current_user: current_user}) do
    changeset = Accounts.change_user(current_user)
    render(conn, "edit.html", user: current_user, changeset: changeset)
  end

  def update(conn, %{"user" => user_params}, %{current_user: current_user}) do
    case Accounts.update_user(current_user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user: user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: current_user, changeset: changeset)
    end
  end
end
