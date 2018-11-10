defmodule PolymorphicProductionsWeb.SessionController do
  use PolymorphicProductionsWeb, :controller

  import PolymorphicProductionsWeb.Authorize

  alias PolymorphicProductions.Sessions
  alias PolymorphicProductionsWeb.Auth.Login
  alias Phauxth.Authenticate
  alias Phauxth.Remember

  # the following plugs are defined in the controllers/authorize.ex file
  plug(:guest_check when action in [:new, :create])
  plug(:id_check when action in [:delete])

  def new(conn, %{"request_path" => request_path}) do
    render(conn, "new.html", request_path: request_path)
  end

  def new(conn, _) do
    render(conn, "new.html", request_path: nil)
  end

  def create(conn, %{"session" => %{"request_path" => request_path} = params}) do
    case Login.verify(params) do
      {:ok, user} ->
        {:ok, %{id: session_id}} = Sessions.create_session(%{user_id: user.id})

        conn
        |> delete_session(:request_path)
        |> Authenticate.add_session(session_id)
        |> add_remember_me(user.id, params)
        |> put_flash(:info, "User successfully logged in.")
        |> redirect(
          to: get_session(conn, :request_path) || request_path || Routes.user_path(conn, :index)
        )

      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def create(conn, %{"session" => _} = params) do
    create(conn, Map.put(params, "request_path", nil))
  end

  def delete(%Plug.Conn{assigns: %{current_user: _user}} = conn, _) do
    {:ok, _} =
      conn
      |> get_session(:phauxth_session_id)
      |> Sessions.get_session()
      |> Sessions.delete_session()

    conn
    |> delete_session(:phauxth_session_id)
    |> Remember.delete_rem_cookie()
    |> put_flash(:info, "User successfully logged out.")
    |> redirect(to: Routes.pix_path(conn, :index))
  end

  # This function adds a remember_me cookie to the conn.
  # See the documentation for Phauxth.Remember for more details.
  defp add_remember_me(conn, user_id, %{"remember_me" => "true"}) do
    Remember.add_rem_cookie(conn, user_id)
  end

  defp add_remember_me(conn, _, _), do: conn
end
