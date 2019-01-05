defmodule PolymorphicProductionsWeb.TagController do
  use PolymorphicProductionsWeb, :controller
  alias PolymorphicProductions.Social

  # def index(conn, _) do
  # end

  def show_pic(conn, %{"tag" => tag} = params) do
    {tag, kerosene} = Social.get_tag!(tag, params)
    render(conn, "show.html", tag: tag, kerosene: kerosene)
  end

  def show_post(conn, %{"tag" => tag} = params) do
    {tag, kerosene} = Social.get_post_tag!(tag, params)
    render(conn, "show_posts.html", tag: tag, kerosene: kerosene)
  end
end
