defmodule PolymorphicProductionsWeb.Email do
  @moduledoc """
  A module for sending emails to the user.

  If you want to use a different email adapter, or another email
  library, read the instructions below.

  ## Bamboo with a different adapter

  Bamboo has adapters for Mailgun, Mailjet, Mandrill, Sendgrid, SMTP,
  SparkPost, PostageApp, Postmark and Sendcloud.

  There is also a LocalAdapter, which is great for local development.

  See [Bamboo](https://github.com/thoughtbot/bamboo) for more information.

  ## Other email library

  If you do not want to use Bamboo, follow the instructions below:

  1. Edit this file, using the email library of your choice
  2. Remove the lib/forks_the_egg_sample/mailer.ex file
  3. Remove the Bamboo entries in the config/config.exs and config/test.exs files
  4. Remove bamboo from the deps section in the mix.exs file

  """
  use Bamboo.Phoenix, view: PolymorphicProductionsWeb.Mailer.EmailView

  import Bamboo.Email
  alias PolymorphicProductionsWeb.Mailer
  alias PolymorphicProductionsWeb.Mailer.LayoutView

  @doc """
  An email sent from the contact form
  """
  def contact_request(conn, %{email: from_email, name: from_name, subject: subject} = contact) do
    new_email()
    |> to({"Josh Chernoff", "jchernoff@polymorphic.productions"})
    |> from({from_name, from_email})
    |> put_html_layout({LayoutView, "email.html"})
    |> assign(:contact, contact)
    |> assign(:conn, conn)
    |> subject(subject)
    |> render("contact.html")
    |> Mailer.deliver_now()
  end

  defp prep_mail(address) do
    new_email()
    |> to(address)
    |> from("noreply@polymorphic.productions")
  end
end
