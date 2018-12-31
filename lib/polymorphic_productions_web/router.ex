defmodule PolymorphicProductionsWeb.Router do
  use PolymorphicProductionsWeb, :router

  if Mix.env() != :test do
    use Plug.ErrorHandler
    use Sentry.Plug
  end

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

    plug(Phauxth.Remember,
      create_session_func: &PolymorphicProductionsWeb.Auth.Utils.create_session/1
    )
  end

  scope "/", PolymorphicProductionsWeb do
    pipe_through(:browser)

    resources("/snapshots", PicController)

    resources "/snapshots", PicController, only: [] do
      resources("/comments", CommentController, only: [:show, :create, :delete, :update])
    end

    get("/snapshots/tag/:tag", TagController, :show)

    get("/signup", UserController, :new)
    post("/signup", UserController, :create)

    get("/account", UserController, :show)
    get("/account/edit", UserController, :edit)
    put("/account", UserController, :update)

    resources("/users", Admin.UserController,
      only: [:index, :show, :edit, :update, :delete],
      as: :admin_user
    )

    resources("/sessions", SessionController, only: [:new, :create, :delete])

    get("/confirm", ConfirmController, :index)

    resources("/password_resets", PasswordResetController, only: [:new, :create])
    get("/password_resets/edit", PasswordResetController, :edit)
    put("/password_resets/update", PasswordResetController, :update)

    get("/contact", ContactController, :new)
    post("/contact", ContactController, :create)

    get("/about", PageController, :about)
    get("/terms", PageController, :terms)
    get("/privacy", PageController, :privacy)
    get("/", PageController, :index)
  end
end
