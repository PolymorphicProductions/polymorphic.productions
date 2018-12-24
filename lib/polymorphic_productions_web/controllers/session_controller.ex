defmodule PolymorphicProductionsWeb.SessionController do
  use PolymorphicProductionsWeb, :controller

  alias Phauxth.Remember
  alias PolymorphicProductions.Sessions
  alias PolymorphicProductionsWeb.Auth.Login

  # the following plug is defined in the controllers/authorize.ex file
  # import PolymorphicProductionsWeb.Authenticate
  # plug(:guest_check when action in [:new, :create])

  def new(conn, _) do
    conn
    |> assign(:nav_class, "navbar navbar-absolute navbar-fixed")
    |> render("new.html",
      layout: {PolymorphicProductionsWeb.LayoutView, "full-header.html"},
      request_path: nil
    )
  end

  def create(conn, %{"session" => params}) do
    case Login.verify(params) do
      {:ok, user} ->
        conn
        |> add_session(user, params)
        |> put_flash(:info, "User successfully logged in.")
        |> redirect(to: get_session(conn, :request_path) || Routes.page_path(conn, :index))

      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def delete(%Plug.Conn{assigns: %{current_user: current_user}} = conn, _) do
    {deleted_sessions_count, _} = Sessions.delete_user_sessions(current_user)

    conn
    |> delete_session(:phauxth_session_id)
    |> Remember.delete_rem_cookie()
    |> put_flash(:info, "See you next time. 👋")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp add_session(conn, user, params) do
    {:ok, %{id: session_id}} = Sessions.create_session(%{user_id: user.id})

    conn
    |> delete_session(:request_path)
    |> put_session(:phauxth_session_id, session_id)
    |> configure_session(renew: true)
    |> add_remember_me(user.id, params)
  end

  # This function adds a remember_me cookie to the conn.
  # See the documentation for Phauxth.Remember for more details.
  defp add_remember_me(conn, user_id, %{"remember_me" => "true"}) do
    Remember.add_rem_cookie(conn, user_id)
  end

  defp add_remember_me(conn, _, _), do: conn
end
