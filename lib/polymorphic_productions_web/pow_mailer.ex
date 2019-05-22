defmodule PolymorphicProductionsWeb.PowMailer do
  require Logger

  @impl true
  def cast(%{user: user, subject: subject, text: text, html: html, assigns: _assigns}) do
    # Build email struct to be used in `process/1`

    %{to: user.email, subject: subject, text: text, html: html}
  end

  @impl true
  def process(email) do
    # Send email

    Logger.debug("E-mail sent: \#{inspect email}")
  end
end
