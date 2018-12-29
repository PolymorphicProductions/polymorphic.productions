# Script for populating the database. You can run it as:
#
#     mix run priv/repo/parse_exif.exs

#  PolymorphicProductions.Repo.insert!(%PolymorphicProductions.SomeSchema{})
alias PolymorphicProductions.Social.Pic
alias PolymorphicProductions.Social
alias PolymorphicProductions.Repo

defmodule Processor do
  def fetch_image(%{asset: asset} = row) do
    charlist = asset |> URI.encode() |> to_charlist

    {:ok, resp} =
      :httpc.request(:get, {charlist, [{'Range', 'bytes=0-4000'}]}, [], body_format: :binary)

    {_status, _headers, body} = resp
    {Exexif.exif_from_jpeg_buffer(body), row}
  end

  def write_row({{:ok, exif}, pic}) do
    {:ok, _pic} = Social.update_pic(pic, %{meta: exif})
  end

  def write_row(_) do
  end
end

Pic
|> Repo.all()
|> Enum.map(fn result -> Task.async(Processor, :fetch_image, [result]) end)
|> Enum.map(&Task.await/1)
|> Enum.map(fn result -> Processor.write_row(result) end)
