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
end
