defmodule PolymorphicProductionsWeb.PostView do
  use PolymorphicProductionsWeb, :view

  def format_date(dt) do
    Timex.format!(dt, "{Mshort} {D}, {YYYY}")
  end

  def render("social.show.html", assigns) do
    {
      :safe,
      """
      <meta property="og:type" content="image/jpeg" />
      <meta property="og:url" content="#{Routes.post_url(assigns[:conn], :show, assigns[:post])}" />
      <meta property="og:title" content="Polymorphic Productions | #{assigns[:post].excerpt} " />
      <meta property="og:description" content="#{assigns[:post].excerpt}" />
      <meta property="og:site_name" content="Polymorphic Productions" />
      <meta name="twitter:site" content="@PolymorphicProd">
      <meta name="twitter:title" content="Polymorphic Productions | #{assigns[:post].title}">
      <meta name="twitter:description" content="#{assigns[:post].excerpt}">
      <meta name="twitter:card" content="summary_large_image">
      <meta name="twitter:widgets:new-embed-design" content="on">
      <meta property="og:image"      content="#{assigns[:post].med_image}" />
      <meta name="twitter:image:src" content="#{assigns[:post].med_image}">
      """
    }
  end

  def time_ago(time) do
    {:ok, relative_str} = time |> Timex.format("{relative}", :relative)

    relative_str
  end

  def parse_markdown(text) do
    case Earmark.as_html(text) do
      {:ok, html_doc, []} ->
        html_doc

      {:error, _html_doc, error_messages} ->
        error_messages
    end
  end

  def parse_tags(conn, tags) do
    tags
    |> Enum.map(fn tag ->
      content_tag(:li, link(tag.name, to: Routes.post_tag_path(conn, :show_post, tag.name)))
    end)
  end
end
