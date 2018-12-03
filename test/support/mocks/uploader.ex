defmodule PolymorphicProductions.Mocks.Uploader do
  def upload(image_path, storage_path, filename) do
  end

  def upload_plug do
    %Plug.Upload{path: "test/assets/user_avatar.jpg", filename: "user_avatar.jpg"}
  end
end
