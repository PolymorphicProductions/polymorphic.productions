defmodule PolymorphicProductionsWeb.Authenticate do
  @moduledoc """
  Functions to help with checking if a given user is logged in.
  """

  import Plug.Conn
  import Phoenix.Controller

  alias PolymorphicProductionsWeb.Router.Helpers, as: Routes

  @doc """
  Plug to check if a given user is logged in.
  """
  def authentication_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    conn
    |> put_session(:request_path, current_path(conn))
    |> put_flash(:error, "🤦‍♂️ You need to log in to view this page 👮‍♂️")
    |> redirect(to: Routes.session_path(conn, :new))
    |> halt()
  end

  def authentication_check(conn, _opts), do: conn
end
