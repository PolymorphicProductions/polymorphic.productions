defmodule PolymorphicProductions.Assets.Processor do
  import Mogrify

  def scale_image(path) do
    path
    |> open()
    |> verbose
    |> resize("1024x683>")
    |> verbose
    |> save()
    |> verbose
  end

  def resize_image(path, resize_command) do
    path
    |> open()
    |> verbose
    |> resize(resize_command)
    |> verbose
    |> save()
    |> verbose
  end
end
