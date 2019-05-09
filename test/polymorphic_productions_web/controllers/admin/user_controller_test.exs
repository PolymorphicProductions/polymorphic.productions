defmodule PolymorphicProductionsWeb.Admin.UserControllerTest do
  use PolymorphicProductionsWeb.ConnCase

  setup %{conn: conn} do
    conn = conn |> bypass_through(PolymorphicProductionsWeb.Router, [:browser]) |> get("/")
    {:ok, %{conn: conn}}
  end

  describe "authed admin" do
    test "renders a list of users", %{conn: conn} do
      conn = get(conn, Routes.admin_user_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Users"
    end

    test "renders form for editing any user", %{conn: conn, user: user} do
      conn = get(conn, Routes.admin_user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "Edit User"
    end

    test "updates any user when data is valid", %{conn: conn, user: user} do
      conn =
        put(conn, Routes.admin_user_path(conn, :update, user), %{"user" => %{name: "foobar"}})

      assert Routes.admin_user_path(conn, :show, user) == redirected_to(conn, 302)
      conn = get(recycle(conn), Routes.admin_user_path(conn, :show, user))
      assert html_response(conn, 200) =~ "User Name: foobar"
    end

    test "does not update any user and renders errors when data is invalid", %{
      conn: conn,
      user: user
    } do
      conn = put(conn, Routes.admin_user_path(conn, :update, user), user: %{email: nil})
      assert html_response(conn, 200) =~ "Edit User"
    end

    test "show any user's page", %{conn: conn, rando: rando} do
      conn = get(conn, Routes.admin_user_path(conn, :show, rando))
      assert html_response(conn, 200) =~ "User Account Setting"
    end

    test "deletes any user", %{conn: conn, rando: rando} do
      conn = delete(conn, Routes.admin_user_path(conn, :delete, rando))
      assert Routes.admin_user_path(conn, :index) == redirected_to(conn, 302)

      # conn = get(recycle(conn), Routes.admin_user_path(conn, :index))
      # assert html_response(conn, 200) =~ "User deleted successfully."
    end
  end
end
