defmodule PolymorphicProductionsWeb.Mailer do
  use Bamboo.Mailer, otp_app: :polymorphic_productions

  # defmacro __using__(:view) do
  #   quote do
  #     use Phoenix.View,
  #       root: "lib/polymorphic_productions_web/templates",
  #       namespace: PolymorphicProductionsWeb.Mailer

  #     # Import convenience functions from controllers
  #     import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

  #     # Use all HTML functionality (forms, tags, etc)
  #     use Phoenix.HTML

  #     alias PolymorphicProductionsWeb.Router.Helpers, as: Routes
  #     import PolymorphicProductionsWeb.Gettext
  #   end
  # end

  defmacro __using__(:view) do
    quote do
      use Phoenix.View,
        root: "lib/polymorphic_productions_web/templates",
        namespace: PolymorphicProductionsWeb.Mailer

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      alias PolymorphicProductionsWeb.Router.Helpers, as: Routes
      import PolymorphicProductionsWeb.Gettext
    end
  end
end
