defmodule PolymorphicProductions.SocialTest do
  use PolymorphicProductions.DataCase

  alias PolymorphicProductions.Social

  describe "pics" do
    alias PolymorphicProductions.Social.Pix

    @valid_attrs %{asset: "some asset", description: "some description"}
    @update_attrs %{asset: "some updated asset", description: "some updated description"}
    @invalid_attrs %{asset: nil, description: nil}

    def pix_fixture(attrs \\ %{}) do
      {:ok, pix} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Social.create_pix()

      pix
    end

    test "list_pics/0 returns all pics" do
      pix = pix_fixture()
      assert Social.list_pics() == [pix]
    end

    test "get_pix!/1 returns the pix with given id" do
      pix = pix_fixture()
      assert Social.get_pix!(pix.id) == pix
    end

    test "create_pix/1 with valid data creates a pix" do
      assert {:ok, %Pix{} = pix} = Social.create_pix(@valid_attrs)
      assert pix.asset == "some asset"
      assert pix.description == "some description"
    end

    test "create_pix/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_pix(@invalid_attrs)
    end

    test "update_pix/2 with valid data updates the pix" do
      pix = pix_fixture()
      assert {:ok, %Pix{} = pix} = Social.update_pix(pix, @update_attrs)

      
      assert pix.asset == "some updated asset"
      assert pix.description == "some updated description"
    end

    test "update_pix/2 with invalid data returns error changeset" do
      pix = pix_fixture()
      assert {:error, %Ecto.Changeset{}} = Social.update_pix(pix, @invalid_attrs)
      assert pix == Social.get_pix!(pix.id)
    end

    test "delete_pix/1 deletes the pix" do
      pix = pix_fixture()
      assert {:ok, %Pix{}} = Social.delete_pix(pix)
      assert_raise Ecto.NoResultsError, fn -> Social.get_pix!(pix.id) end
    end

    test "change_pix/1 returns a pix changeset" do
      pix = pix_fixture()
      assert %Ecto.Changeset{} = Social.change_pix(pix)
    end
  end

  describe "comments" do
    alias PolymorphicProductions.Social.Comment

    @valid_attrs %{approved: true, author: "some author", body: "some body"}
    @update_attrs %{approved: false, author: "some updated author", body: "some updated body"}
    @invalid_attrs %{approved: nil, author: nil, body: nil}

    def comment_fixture(attrs \\ %{}) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Social.create_comment()

      comment
    end

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Social.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Social.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = Social.create_comment(@valid_attrs)
      assert comment.approved == true
      assert comment.author == "some author"
      assert comment.body == "some body"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{} = comment} = Social.update_comment(comment, @update_attrs)

      
      assert comment.approved == false
      assert comment.author == "some updated author"
      assert comment.body == "some updated body"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Social.update_comment(comment, @invalid_attrs)
      assert comment == Social.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Social.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Social.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Social.change_comment(comment)
    end
  end
end
