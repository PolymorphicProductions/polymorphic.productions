defmodule PolymorphicProductionsWeb.Sitemap do
  alias PolymorphicProductionsWeb.Endpoint
  alias PolymorphicProductionsWeb.Router.Helpers, as: Routes

  use Sitemap,
    host: "http://#{Application.get_env(:polymorphic_productions, Endpoint)[:url][:host]}",
    files_path:
      "lib/polymorphic_productions-#{Application.spec(:polymorphic_productions, :vsn)}/priv/static/sitemaps/",
    public_path: "sitemaps/"

  def generate do
    create do
      # list each URL that should be included, using your application's routes
      add(Routes.page_path(Endpoint, :index), priority: 0.7, changefreq: "weekly", expires: nil)
      add(Routes.page_path(Endpoint, :about), priority: 0.5, changefreq: "monthly", expires: nil)

      add(Routes.contact_path(Endpoint, :new),
        priority: 0.4,
        changefreq: "monthly",
        expires: nil
      )

      add(Routes.pic_path(Endpoint, :index),
        priority: 1.0,
        changefreq: "weekly",
        expires: nil
      )

      add(Routes.user_path(Endpoint, :new),
        priority: 0.2,
        changefreq: "never",
        expires: nil
      )

      # ...
    end

    # notify search engines (currently Google and Bing) of the updated sitemap
    ping()
  end
end
