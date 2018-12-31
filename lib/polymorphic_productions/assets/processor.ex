defmodule PolymorphicProductions.Assets.Processor do
  import Mogrify

  def scale_image(path) do
    path
    |> IO.inspect()
    |> open()
    |> verbose
    |> resize("1024x683>")
    |> verbose
    |> save()
    |> verbose
  end
end
