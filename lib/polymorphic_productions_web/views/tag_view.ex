defmodule PolymorphicProductionsWeb.TagView do
  use PolymorphicProductionsWeb, :view

  def format_date(dt) do
    Timex.format!(dt, "{Mshort} {D}, {YYYY}")
  end

  def time_ago(time) do
    {:ok, relative_str} = time |> Timex.format("{relative}", :relative)

    relative_str
  end

  def parse_tags(content) do
    content
    |> String.replace(~r/#(\w*)/, "<a href='/snapshots/tag/\\1'>#\\1</a>")
  end
end
