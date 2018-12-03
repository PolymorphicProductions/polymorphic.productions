defmodule PolymorphicProductions.Assets.Uploader do
  alias ExAws.S3

  def upload(image_path, storage_path, filename) do
    image_path
    |> S3.Upload.stream_file()
    |> S3.upload("polymorphic-productions", storage_path <> filename, acl: :public_read)
    |> ExAws.request()
  end
end
