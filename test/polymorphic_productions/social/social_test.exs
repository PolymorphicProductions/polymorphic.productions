defmodule PolymorphicProductions.SocialTest do
  use PolymorphicProductions.DataCase

  alias PolymorphicProductions.Social

  import PolymorphicProductions.Factory

  describe "pics" do
    alias PolymorphicProductions.Social.Pix

    @valid_attrs string_params_for(:pix)
    @update_attrs string_params_for(:pix)
    @invalid_attrs Map.from_struct(%PolymorphicProductions.Social.Pix{})

    test "list_pics/0 returns all pics" do
      pix = insert(:pix)
      {pics, _kerosene} = Social.list_pics()
      assert pics == [pix]
    end

    test "get_pix!/1 returns the pix with given id" do
      pix = insert(:pix)
      assert Social.get_pix!(pix.id) == pix
    end

    test "create_pix/1 with valid data creates a pix" do
      param =
        Map.merge(@valid_attrs, %{"photo" => PolymorphicProductions.Mocks.Uploader.upload_plug()})

      assert {:ok, %Pix{} = pix} = Social.create_pix(param)

      assert pix.asset ==
               "https://d1sv288qkuffrb.cloudfront.net/polymorphic-productions/photos/user_avatar.jpg"

      assert pix.asset_preview ==
               "https://d1sv288qkuffrb.cloudfront.net/polymorphic-productions/photos/preview/user_avatar.jpg"

      assert(pix.description == "A street photo of ...")
    end

    test "create_pix/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_pix(@invalid_attrs)
    end

    test "update_pix/2 with valid data updates the pix" do
      pix = insert(:pix)
      assert {:ok, %Pix{} = pix} = Social.update_pix(pix, @update_attrs)

      assert pix.asset == @update_attrs["asset"]
      assert pix.description == @update_attrs["description"]
    end

    test "update_pix/2 with invalid data returns error changeset" do
      pix = insert(:pix)
      assert {:error, %Ecto.Changeset{}} = Social.update_pix(pix, @invalid_attrs)
      assert pix == Social.get_pix!(pix.id)
    end

    test "delete_pix/1 deletes the pix" do
      pix = insert(:pix)
      assert {:ok, %Pix{}} = Social.delete_pix(pix)
      assert_raise Ecto.NoResultsError, fn -> Social.get_pix!(pix.id) end
    end

    test "change_pix/1 returns a pix changeset" do
      pix = insert(:pix)
      assert %Ecto.Changeset{} = Social.change_pix(pix)
    end
  end

  describe "comments" do
    alias PolymorphicProductions.Social.Comment

    @valid_attrs string_params_for(:comment)
    @update_attrs string_params_for(:comment)
    @invalid_attrs Map.from_struct(%PolymorphicProductions.Social.Comment{})

    test "list_comments/0 returns all comments" do
      comment = insert(:comment)

      assert Social.list_comments() == [
               %{
                 comment
                 | user: %Ecto.Association.NotLoaded{
                     __field__: :user,
                     __cardinality__: :one,
                     __owner__: PolymorphicProductions.Social.Comment
                   }
               }
             ]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = insert(:comment, pix: nil)
      assert Social.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = Social.create_comment(@valid_attrs)
      assert comment.approved == true
      # assert comment.user == @update_attrs["user"]
      assert comment.body == @update_attrs["body"]
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = insert(:comment)
      assert {:ok, %Comment{} = comment} = Social.update_comment(comment, @update_attrs)

      assert comment.approved == true
      # assert comment.user == @update_attrs["user"]
      assert comment.body == @update_attrs["body"]
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = insert(:comment, pix: nil)

      assert {:error, %Ecto.Changeset{}} = Social.update_comment(comment, @invalid_attrs)

      assert comment == Social.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = insert(:comment)

      assert {:ok, %Comment{}} = Social.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Social.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = insert(:comment)
      assert %Ecto.Changeset{} = Social.change_comment(comment)
    end
  end
end
