defmodule PolymorphicProductionsWeb.ConfirmController do
  use PolymorphicProductionsWeb, :controller

  import PolymorphicProductionsWeb.Authorize
  alias PolymorphicProductions.Accounts

  def index(conn, params) do
    case Phauxth.Confirm.verify(params, Accounts) do
      {:ok, user} ->
        Accounts.confirm_user(user)
        message = "Your account has been confirmed"
        Accounts.Message.confirm_success(user.email)
        success(conn, message, Routes.session_path(conn, :new))

      {:error, message} ->
        error(conn, message, Routes.session_path(conn, :new))
    end
  end
end
