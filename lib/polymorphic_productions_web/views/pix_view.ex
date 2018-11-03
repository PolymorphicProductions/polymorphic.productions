defmodule PolymorphicProductionsWeb.PixView do
  use PolymorphicProductionsWeb, :view

  def format_date(dt) do
    Timex.format!(dt, "{Mshort} {D}, {YYYY}")
  end

  def render("social.show.html", assigns) do
    {
      :safe,
      "<meta name=\"twitter:card\" content=\"summary_large_image\" />
      <meta name=\"ttwitter:site\" content=\"@PolymorphicProd\" />
      <meta property=\"og:image\" content=\"#{assigns[:pix].asset}\" />"
    }
  end
end
