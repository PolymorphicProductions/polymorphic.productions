defmodule PolymorphicProductions.Mocks.Processor do
  def scale_image(_path) do
    %{path: "some-fake-image-path"}
  end
end
