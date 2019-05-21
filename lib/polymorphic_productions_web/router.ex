defmodule PolymorphicProductionsWeb.Router do
  use PolymorphicProductionsWeb, :router
  use Pow.Phoenix.Router

  if Mix.env() != :test do
    use Plug.ErrorHandler
    use Sentry.Plug
  end

  if Mix.env() == :dev do
    forward("/sent_emails", Bamboo.SentEmailViewerPlug)
  end

  @spec set_nav_style(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def set_nav_style(conn, _), do: assign(conn, :nav_class, "navbar navbar-absolute navbar-fixed")

  pipeline :pow_layout do
    plug(:put_layout, {PolymorphicProductionsWeb.LayoutView, "full-header.html"})
    plug(:set_nav_style)
  end

  scope("/") do
    pipe_through([:browser, :pow_layout])
    pow_session_routes()
    pow_extension_routes()
    resources("/registration", Pow.Phoenix.RegistrationController, singleton: true, only: [:new])
  end

  scope "/" do
    pipe_through(:browser)
    pow_registration_routes()
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(CORSPlug, origin: Application.get_env(:polymorphic_productions, :cors_origin))
    plug(:accepts, ["json"])
    plug(:fetch_session)
  end

  scope "/", PolymorphicProductionsWeb do
    pipe_through(:browser)

    get("/snapshots/tag/:tag", TagController, :show_pic, as: :pic_tag)

    resources("/snapshots", PicController)

    resources "/snapshots", PicController do
      resources("/comments", CommentController, only: [:show, :create, :delete, :update])
    end

    get("/posts/tag/:tag", TagController, :show_post, as: :post_tag)

    resources "/posts", PostController, param: "slug" do
      resources("/comments", CommentController, only: [:show, :create, :delete, :update])
    end

    # get("/account", UserController, :show)
    # get("/account/edit", UserController, :edit)
    # put("/account", UserController, :update)

    resources("/users", Admin.UserController,
      only: [:index, :show, :edit, :update, :delete],
      as: :admin_user
    )

    get("/contact", ContactController, :new)
    post("/contact", ContactController, :create)

    get("/about", PageController, :about)
    get("/terms", PageController, :terms)
    get("/privacy", PageController, :privacy)
    get("/", PageController, :index)
  end
end
