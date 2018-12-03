defmodule PolymorphicProductionsWeb.Auth.Utils do
  @moduledoc """
  Helper functions for authentication.
  """

  alias PolymorphicProductions.Sessions

  def create_session(%Plug.Conn{assigns: %{current_user: %{id: user_id}}}) do
    Sessions.create_session(%{user_id: user_id})
  end
end
