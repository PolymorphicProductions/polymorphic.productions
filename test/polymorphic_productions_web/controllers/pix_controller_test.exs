defmodule PolymorphicProductionsWeb.PixControllerTest do
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
      conn = get(conn, Routes.pix_path(conn, :index))
      assert html_response(conn, 200)
    end
  end

  describe "new pix" do
    setup [:log_admin_in]

    test "renders form", %{conn: conn, user: user} do
      conn = get(conn, Routes.pix_path(conn, :new))
      assert html_response(conn, 200) =~ "New Pix"
    end
  end

  describe "create pix" do
    setup [:log_admin_in]

    test "redirects to show when data is valid", %{conn: conn, user: user} do
      conn = post(conn, Routes.pix_path(conn, :create), pix: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.pix_path(conn, :show, id)

      conn = get(conn, Routes.pix_path(conn, :show, id))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.pix_path(conn, :create), pix: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Pix"
    end
  end

  describe "edit pix" do
    setup [:create_pix, :log_admin_in]

    test "renders form for editing chosen pix", %{conn: conn, pix: pix, user: user} do
      conn = get(conn, Routes.pix_path(conn, :edit, pix))
      assert html_response(conn, 200) =~ "Edit Pix"
    end
  end

  describe "update pix" do
    setup [:create_pix, :log_admin_in]

    test "redirects when data is valid", %{conn: conn, pix: pix} do
      conn = put(conn, Routes.pix_path(conn, :update, pix), pix: @update_attrs)
      assert redirected_to(conn) == Routes.pix_path(conn, :show, pix)

      conn = get(conn, Routes.pix_path(conn, :show, pix))
      assert html_response(conn, 200) =~ @update_attrs.description
    end

    test "renders errors when data is invalid", %{conn: conn, pix: pix} do
      conn = put(conn, Routes.pix_path(conn, :update, pix), pix: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Pix"
    end
  end

  describe "delete pix" do
    setup [:create_pix, :log_admin_in]

    test "deletes chosen pix", %{conn: conn, pix: pix} do
      conn = delete(conn, Routes.pix_path(conn, :delete, pix))

      assert redirected_to(conn) == Routes.pix_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, Routes.pix_path(conn, :show, pix))
      end)
    end
  end

  defp create_pix(_) do
    {:ok, pix} = Social.create_pix(@create_attrs)
    {:ok, pix: pix}
  end
end
