defmodule PolymorphicProductions.Assets.Processor do
  import Mogrify

  def scale_image(path) do
    path
    |> open()
    |> resize("1024x")
    |> save()
  end
end
