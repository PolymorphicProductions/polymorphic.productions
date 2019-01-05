defmodule PolymorphicProductions.Social.Tag do
  import Ecto.Query
  use Ecto.Schema

  schema "tags" do
    field(:name)
    many_to_many(:pics, PolymorphicProductions.Social.Pic, join_through: "pic_tags")
    many_to_many(:posts, PolymorphicProductions.Social.Post, join_through: "post_tags")
  end
end
