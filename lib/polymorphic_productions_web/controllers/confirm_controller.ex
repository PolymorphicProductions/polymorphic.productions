defmodule PolymorphicProductionsWeb.ConfirmController do
  use PolymorphicProductionsWeb, :controller

  alias Phauxth.Confirm
  alias PolymorphicProductions.Accounts
  alias PolymorphicProductionsWeb.Email

  def index(conn, params) do
    import IEx
    IEx.pry()

    case Confirm.verify(params) do
      {:ok, user} ->
        Accounts.confirm_user(user)
        Email.confirm_success(user.email)

        conn
        |> put_flash(:info, "Your account has been confirmed")
        |> redirect(to: Routes.session_path(conn, :new))

      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end
end
