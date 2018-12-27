defmodule PolymorphicProductionsWeb.PicControllerTest do
  use PolymorphicProductionsWeb.ConnCase

  import PolymorphicProductionsWeb.AuthCase

  alias PolymorphicProductions.Social

  @create_attrs %{
    asset: "some asset",
    description: "some description",
    photo: %Plug.Upload{path: "test/fixtures/image.jpg", filename: "image.jpg"}
  }
  @update_attrs %{
    asset: "some updated asset",
    description: "some updated description",
    photo: %Plug.Upload{path: "test/fixtures/image.jpg", filename: "image.jpg"}
  }

  @invalid_attrs %{asset: nil, description: nil, photo: nil}

  setup %{conn: conn} do
    conn = conn |> bypass_through(PolymorphicProductionsWeb.Router, [:browser]) |> get("/")
    {:ok, %{conn: conn}}
  end

  describe "index" do
    test "lists all pics", %{conn: conn} do
      conn = get(conn, Routes.pic_path(conn, :index))
      assert html_response(conn, 200)
    end
  end

  describe "new pic" do
    setup [:log_admin_in]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.pic_path(conn, :new))
      assert html_response(conn, 200) =~ "New Pic"
    end
  end

  describe "create pic" do
    setup [:log_admin_in]

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.pic_path(conn, :create), pic: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.pic_path(conn, :show, id)

      conn = get(conn, Routes.pic_path(conn, :show, id))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.pic_path(conn, :create), pic: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Pic"
    end
  end

  describe "edit pic" do
    setup [:create_pic, :log_admin_in]

    test "renders form for editing chosen pic", %{conn: conn, pic: pic} do
      conn = get(conn, Routes.pic_path(conn, :edit, pic))
      assert html_response(conn, 200) =~ "Edit Pic"
    end
  end

  describe "update pic" do
    setup [:create_pic, :log_admin_in]

    test "redirects when data is valid", %{conn: conn, pic: pic} do
      conn = put(conn, Routes.pic_path(conn, :update, pic), pic: @update_attrs)
      assert redirected_to(conn) == Routes.pic_path(conn, :show, pic)

      conn = get(conn, Routes.pic_path(conn, :show, pic))
      assert html_response(conn, 200) =~ @update_attrs.description
    end

    test "renders errors when data is invalid", %{conn: conn, pic: pic} do
      conn = put(conn, Routes.pic_path(conn, :update, pic), pic: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Pic"
    end
  end

  describe "delete pic" do
    setup [:create_pic, :log_admin_in]

    test "deletes chosen pic", %{conn: conn, pic: pic} do
      conn = delete(conn, Routes.pic_path(conn, :delete, pic))

      assert redirected_to(conn) == Routes.pic_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, Routes.pic_path(conn, :show, pic))
      end)
    end
  end

  defp create_pic(_) do
    {:ok, pic} = Social.create_pic(@create_attrs)
    {:ok, pic: pic}
  end
end
