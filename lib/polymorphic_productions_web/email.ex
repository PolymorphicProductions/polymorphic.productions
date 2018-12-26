defmodule PolymorphicProductionsWeb.Email do
  @moduledoc """
  A module for sending emails to the user.

  This module provides functions to be used with the Phauxth authentication
  library when confirming users or handling password resets. It uses
  Bamboo, with the Mandrill adapter, to email users. For tests, it uses
  a test adapter, which is configured in the config/test.exs file.

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
  def contact_request(
        conn,
        %{id: _, email: email, name: name, subject: subject, message: message} = contact
      ) do
    new_email()
    |> to({"Josh Chernoff", "jchernoff@polymorphic.productions"})
    |> from({name, email})
    |> put_html_layout({LayoutView, "email.html"})
    |> assign(:contact, contact)
    |> assign(:conn, conn)
    |> subject(subject)
    |> render("contact.html")
    |> Mailer.deliver_now()
  end

  @doc """
  An email with a confirmation link in it.
  """
  def confirm_request(conn, user, key) do
    prep_mail(user.email)
    |> subject("Confirm your account | Polymorphic Productions")
    # |> text_body("Confirm your email here #{Routes.confirm_path(conn, :index, key: key)}")
    |> put_html_layout({LayoutView, "email.html"})
    |> assign(:user, user)
    |> assign(:key, key)
    |> assign(:conn, conn)
    |> render("invite.html")
    |> Mailer.deliver_later()
  end

  def reset_request(conn, address, key) do
    prep_mail(address)
    |> subject("Reset your password")
    |> put_html_layout({LayoutView, "email.html"})
    |> text_body(
      "Reset your password at https://polymorphic.productions/password_resets/edit?key=#{key}"
    )
    |> assign(:address, address)
    |> assign(:key, key)
    |> assign(:conn, conn)
    |> render("pass_reset.html")
    |> Mailer.deliver_later()
  end

  @doc """
  An email acknowledging that the account has been successfully confirmed.
  """
  def confirm_success(address) do
    prep_mail(address)
    |> put_html_layout({LayoutView, "email.html"})
    |> subject("Confirmed account")
    |> text_body("Your account has been confirmed.")
    |> render("confirm_success.html")
    |> Mailer.deliver_now()
  end

  @doc """
  An email acknowledging that the password has been successfully reset.
  """
  def reset_success(address) do
    prep_mail(address)
    |> put_html_layout({LayoutView, "email.html"})
    |> subject("Password reset")
    |> text_body("Your password has been reset.")
    |> Mailer.deliver_now()
  end

  defp prep_mail(address) do
    new_email()
    |> to(address)
    |> from("noreply@polymorphic.productions")
  end
end
