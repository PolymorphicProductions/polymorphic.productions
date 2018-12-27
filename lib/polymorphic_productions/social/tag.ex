defmodule PolymorphicProductions.Social.Tag do
  import Ecto.Query
  use Ecto.Schema

  schema "tags" do
    field(:name)
    many_to_many(:pics, PolymorphicProductions.Social.Pic, join_through: "pic_tags")
  end
end
