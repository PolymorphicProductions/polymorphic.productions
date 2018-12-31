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
      :httpc.request(:get, {charlist, [{'Range', 'bytes=0-6000'}]}, [], body_format: :binary)

    {_status, _headers, body} = resp

    {body, row}
  end

  def write_row({body, row}) do
    # Uses ecto 
    try do
      case Exexif.exif_from_jpeg_buffer(body) do
        {:ok, exif} ->
          {:ok, _pic} = PolymorphicProductions.Social.update_pic(row, %{meta: exif})

        _ ->
          nil
      end
    rescue
      e ->
        nil
    end
  end

  def write_row(_) do
  end
end

Pic
|> Repo.all()
|> Enum.map(fn result -> Task.async(Processor, :fetch_image, [result]) end)
|> Enum.map(&Task.await/1)
|> Enum.map(fn result -> Processor.write_row(result) end)
