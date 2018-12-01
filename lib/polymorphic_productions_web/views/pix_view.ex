defmodule PolymorphicProductionsWeb.PixView do
  use PolymorphicProductionsWeb, :view

  def format_date(dt) do
    Timex.format!(dt, "{Mshort} {D}, {YYYY}")
  end

  def render("social.show.html", assigns) do
    {
      :safe,
      """
      <meta property="og:type" content="image/jpeg" />
      <meta property="og:url" content="#{Routes.pix_url(assigns[:conn], :show, assigns[:pix])}" />
      <meta property="og:title" content="Polymorphic Productions Snapshot" />
      <meta property="og:description" content="#{assigns[:pix].description}" />
      <meta property="og:site_name" content="Polymorphic Productions" />
      <meta name="twitter:site" content="@PolymorphicProd">
      <meta name="twitter:title" content="Polymorphic Productions | Snaps">
      <meta name="twitter:description" content="#{assigns[:pix].description}">
      <meta name="twitter:card" content="summary_large_image">
      <meta name="twitter:widgets:new-embed-design" content="on">
      <meta property="og:image"      content="#{assigns[:pix].asset_preview}" />
      <meta name="twitter:image:src" content="#{assigns[:pix].asset_preview}">
      """
    }
  end

  def time_ago(time) do
    {:ok, relative_str} = time |> Timex.format("{relative}", :relative)

    relative_str
  end
end
