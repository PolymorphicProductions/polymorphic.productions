defmodule PolymorphicProductionsWeb.PageController do
  use PolymorphicProductionsWeb, :controller

  alias PolymorphicProductions.Social

  # plug(:reload_user when action in [:index])

  # defp reload_user(conn, _opts) do
  #   config = Pow.Plug.fetch_config(conn)
  #   user = Pow.Plug.current_user(conn, config)
  #   reloaded_user = PolymorphicProductions.Repo.get(PolymorphicProductions.Accounts.User, user.id)

  #   Pow.Plug.assign_current_user(conn, reloaded_user, config)
  # end

  @spec index(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def index(conn, _params) do
    # latest_posts = Social.list_posts(limit: 2)
    {latest_pics, _} = Social.list_pics()

    conn
    |> assign(:nav_class, "navbar navbar-absolute navbar-fixed")
    |> render("index.html",
      layout: {PolymorphicProductionsWeb.LayoutView, "full-header.html"},
      latest_pics: latest_pics
    )
  end

  @spec about(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def about(conn, _params) do
    conn
    |> assign(:nav_class, "navbar navbar-absolute navbar-fixed")
    |> render("about.html", layout: {PolymorphicProductionsWeb.LayoutView, "full-header.html"})
  end

  @spec terms(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def terms(conn, _params) do
    conn
    |> assign(:nav_class, "navbar navbar-absolute navbar-fixed")
    |> render("terms.html", layout: {PolymorphicProductionsWeb.LayoutView, "full-header.html"})
  end

  @spec privacy(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def privacy(conn, _params) do
    conn
    |> assign(:nav_class, "navbar navbar-absolute navbar-fixed")
    |> render("privacy.html", layout: {PolymorphicProductionsWeb.LayoutView, "full-header.html"})
  end
end
