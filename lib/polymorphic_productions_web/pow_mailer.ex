defmodule PolymorphicProductionsWeb.PowMailer do
  use Pow.Phoenix.Mailer
  use Bamboo.Phoenix, view: PolymorphicProductionsWeb.Mailer.EmailView

  import Bamboo.Email
  alias PolymorphicProductionsWeb.Mailer
  alias PolymorphicProductionsWeb.Mailer.LayoutView

  require Logger

  def cast(%{user: user, subject: subject, text: text, html: html, assigns: assigns}) do
    # Build email struct to be used in `process/1`

    user.email
    |> prep_mail()
    |> subject(subject)
    |> put_html_layout({LayoutView, "email.html"})
    |> assign(:address, user.email)
  end

  def process(email) do
    # Send email
    Mailer.deliver_now(email)
  end

  defp prep_mail(address) do
    new_email()
    |> to(address)
    |> from("noreply@polymorphic.productions")
  end
end
