defmodule PolymorphicProductionsWeb.PixView do
  use PolymorphicProductionsWeb, :view

  def format_date(dt) do
    Timex.format!(dt, "{Mshort} {D}, {YYYY}")
  end
end
