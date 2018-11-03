defmodule PolymorphicProductionsWeb.PageController do
  use PolymorphicProductionsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", layout: {PolymorphicProductionsWeb.LayoutView, "full-header.html"})
  end
end
