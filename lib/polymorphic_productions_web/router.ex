defmodule PolymorphicProductionsWeb.Router do
  use PolymorphicProductionsWeb, :router

  # use Plug.ErrorHandler
  # use Sentry.Plug

  if Mix.env() == :dev do
    # If using Phoenix
    forward("/sent_emails", Bamboo.SentEmailViewerPlug)
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Phauxth.Authenticate)
  end

  scope "/", PolymorphicProductionsWeb do
    pipe_through(:browser)

    resources("/snapshots", PixController)
    resources("/users", UserController)
    resources("/sessions", SessionController, only: [:new, :create, :delete])
    get("/confirm", ConfirmController, :index)
    resources("/password_resets", PasswordResetController, only: [:new, :create])
    get("/password_resets/edit", PasswordResetController, :edit)
    put("/password_resets/update", PasswordResetController, :update)
    get("/", PageController, :index)
  end
end
