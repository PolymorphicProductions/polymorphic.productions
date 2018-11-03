defmodule PolymorphicProductionsWeb.PageView do
  use PolymorphicProductionsWeb, :view

  def render("navbar.index.html", assigns) do
    "navbar navbar-absolute navbar-fixed"
  end
end
