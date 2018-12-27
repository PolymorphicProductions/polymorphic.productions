defmodule PolymorphicProductions.Mocks.Processor do
  def scale_image(_path) do
    %{path: "some-fake-image-path", width: 100, height: 100}
  end
end
