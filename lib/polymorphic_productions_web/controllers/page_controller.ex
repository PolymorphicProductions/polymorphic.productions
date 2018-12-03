defmodule PolymorphicProductionsWeb.PageController do
  use PolymorphicProductionsWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:nav_class, "navbar navbar-absolute navbar-fixed")
    |> render("index.html", layout: {PolymorphicProductionsWeb.LayoutView, "full-header.html"})
  end

  def about(conn, _params) do
    conn
    |> assign(:nav_class, "navbar navbar-absolute navbar-fixed")
    |> render("about.html", layout: {PolymorphicProductionsWeb.LayoutView, "full-header.html"})
  end

  def terms(conn, _params) do
    conn
    |> assign(:nav_class, "navbar navbar-absolute navbar-fixed")
    |> render("terms.html", layout: {PolymorphicProductionsWeb.LayoutView, "full-header.html"})
  end

  def privacy(conn, _params) do
    conn
    |> assign(:nav_class, "navbar navbar-absolute navbar-fixed")
    |> render("privacy.html", layout: {PolymorphicProductionsWeb.LayoutView, "full-header.html"})
  end
end
