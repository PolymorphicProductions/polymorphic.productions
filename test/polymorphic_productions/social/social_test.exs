defmodule PolymorphicProductions.SocialTest do
  use PolymorphicProductions.DataCase

  alias PolymorphicProductions.Social

  import PolymorphicProductions.Factory

  describe "pics" do
    alias PolymorphicProductions.Social.Pic

    @valid_attrs string_params_for(:pic)
    @update_attrs string_params_for(:pic)
    @invalid_attrs Map.from_struct(%PolymorphicProductions.Social.Pic{})

    test "list_pics/0 returns all pics" do
      pic = insert(:pic)
      {pics, _kerosene} = Social.list_pics()
      assert pics == [pic]
    end

    test "get_pic!/1 returns the pic with given id" do
      pic = insert(:pic)
      assert Social.get_pic!(pic.id) == pic
    end

    test "create_pic/1 with valid data creates a pic" do
      param =
        Map.merge(@valid_attrs, %{"photo" => PolymorphicProductions.Mocks.Uploader.upload_plug()})

      assert {:ok, %Pic{} = pic} = Social.create_pic(param)

      assert pic.asset ==
               "https://d1sv288qkuffrb.cloudfront.net/polymorphic-productions/photos/user_avatar.jpg"

      assert pic.asset_preview ==
               "https://d1sv288qkuffrb.cloudfront.net/polymorphic-productions/photos/preview/user_avatar.jpg"

      assert(pic.description == "A street photo of #PDX #OR")
    end

    test "create_pic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_pic(@invalid_attrs)
    end

    test "update_pic/2 with valid data updates the pic" do
      pic = insert(:pic)
      assert {:ok, %Pic{} = pic} = Social.update_pic(pic, @update_attrs)

      assert pic.asset == @update_attrs["asset"]
      assert pic.description == @update_attrs["description"]
    end

    test "update_pic/2 with invalid data returns error changeset" do
      pic = insert(:pic)
      assert {:error, %Ecto.Changeset{}} = Social.update_pic(pic, @invalid_attrs)
      assert pic == Social.get_pic!(pic.id)
    end

    test "delete_pic/1 deletes the pic" do
      pic = insert(:pic)
      assert {:ok, %Pic{}} = Social.delete_pic(pic)
      assert_raise Ecto.NoResultsError, fn -> Social.get_pic!(pic.id) end
    end

    test "change_pic/1 returns a pic changeset" do
      pic = insert(:pic)
      assert %Ecto.Changeset{} = Social.change_pic(pic)
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
      comment = insert(:comment, pic: nil)
      assert Social.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = Social.create_comment(@valid_attrs)
      assert comment.approved == true
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
      comment = insert(:comment, pic: nil)

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

  @tag skip: "needs more work to get passing"
  describe "posts" do
    alias PolymorphicProductions.Social.Post

    @valid_attrs %{
      body: "some body",
      excerpt: "some excerpt",
      published_at: ~D[2010-04-17],
      slug: "some slug",
      title: "some title"
    }
    @update_attrs %{
      body: "some updated body",
      excerpt: "some updated excerpt",
      published_at: ~D[2011-05-18],
      slug: "some updated slug",
      title: "some updated title"
    }
    @invalid_attrs %{body: nil, excerpt: nil, published_at: nil, slug: nil, title: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Social.create_post()

      post
    end

    @tag skip: "needs more work to get passing"
    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Social.list_posts() == [post]
    end

    @tag skip: "needs more work to get passing"
    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Social.get_post!(post.id) == post
    end

    @tag skip: "needs more work to get passing"
    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Social.create_post(@valid_attrs)
      assert post.body == "some body"
      assert post.excerpt == "some excerpt"
      assert post.published_at == ~D[2010-04-17]
      assert post.slug == "some slug"
      assert post.title == "some title"
    end

    @tag skip: "needs more work to get passing"
    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_post(@invalid_attrs)
    end

    @tag skip: "needs more work to get passing"
    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = Social.update_post(post, @update_attrs)
      assert post.body == "some updated body"
      assert post.excerpt == "some updated excerpt"
      assert post.published_at == ~D[2011-05-18]
      assert post.slug == "some updated slug"
      assert post.title == "some updated title"
    end

    @tag skip: "needs more work to get passing"
    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Social.update_post(post, @invalid_attrs)
      assert post == Social.get_post!(post.id)
    end

    @tag skip: "needs more work to get passing"
    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Social.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Social.get_post!(post.id) end
    end

    @tag skip: "needs more work to get passing"
    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Social.change_post(post)
    end
  end
end
