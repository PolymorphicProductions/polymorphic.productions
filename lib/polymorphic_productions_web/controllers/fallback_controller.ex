defmodule PolymorphicProductionsWeb.FallbackController do
  use PolymorphicProductionsWeb, :controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:forbidden)
    |> render(PolymorphicProductionsWeb.ErrorView, :"403")
  end
end
