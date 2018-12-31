defmodule PolymorphicProductions.ProcessorTest do
  use PolymorphicProductions.DataCase
  # use ExUnit.Case, async: true

  alias PolymorphicProductions.Assets.Processor

  test "scale_image/1 returns all a scalled image" do
    path = Path.join(__DIR__, "../../support/fixtures/image.jpg")
    %{width: width, height: height} = Processor.scale_image(path)
    assert width == 1022
    assert height == 683
  end
end
