defmodule PolymorphicProductions.Mocks.Uploader do
  def upload(_image_path, _storage_path, _filename) do
  end

  def upload_plug do
    %Plug.Upload{path: "test/assets/user_avatar.jpg", filename: "user_avatar.jpg"}
  end
end
