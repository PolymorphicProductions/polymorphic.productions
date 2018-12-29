defmodule PolymorphicProductions.Repo.Migrations.ParseExif do
  use Ecto.Migration

  alias PolymorphicProductions.Social.Pic
  alias PolymorphicProductions.Repo

  def up do
    Pic
    |> Repo.all()
    |> Enum.map(fn result -> Task.async(result |> fetch_image) end)
    |> Enum.map(&Task.await/1)
    |> Enum.each(&IO.inspect/1)

    raise("foo")
  end

  def down do
    # do no harm
  end

  defp fetch_image(%{asset: asset}) do
    {:ok, resp} = :httpc.request(:get, {asset, [{'Range', 'bytes=0-1000'}]}, [], body_format: :binary)

    {_status, _headers, body} = resp
    Exexif.exif_from_jpeg_buffer(body) |> IO.inspect()
  end
end
