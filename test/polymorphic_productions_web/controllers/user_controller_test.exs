defmodule PolymorphicProductionsWeb.UserControllerTest do
  use PolymorphicProductionsWeb.ConnCase

  import PolymorphicProductions.Factory
  import PolymorphicProductionsWeb.AuthCase
  # alias PolymorphicProductions.Accounts
  @create_attrs params_for(:user)

  setup %{conn: conn} do
    conn = conn |> bypass_through(PolymorphicProductionsWeb.Router, [:browser]) |> get("/")
    {:ok, %{conn: conn}}
  end

  describe "as guest" do
    test "renders new form for guest", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 200) =~ "Registration"
    end

    test "redirects to homepage when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      redirect_path = Routes.session_path(conn, :new)
      assert redirect_path == redirected_to(conn, 302)

      conn = get(recycle(conn), redirect_path)
      assert html_response(conn, 200) =~ "User created successfully."
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: %{})
      assert html_response(conn, 200) =~ "Registration"
      assert html_response(conn, 200) =~ "Please check the errors below."
    end

    test "redirects guest to login when visiting User show", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :show))
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "redirects guest to login when visiting User edit", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :edit))
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "redirects guest to login when visiting User update", %{conn: conn} do
      conn = put(conn, Routes.user_path(conn, :update))
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end
  end

  describe "authed user" do
    setup [:log_user_in]

    test "renders form for editing current user", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :edit))
      assert html_response(conn, 200) =~ "Edit User"
    end

    test "updates current user when data is valid", %{conn: conn} do
      conn = put(conn, Routes.user_path(conn, :update), %{"user" => %{name: "foobar"}})
      assert Routes.user_path(conn, :show) == redirected_to(conn, 302)
      conn = get(recycle(conn), Routes.user_path(conn, :show))
      assert html_response(conn, 200) =~ "User Name: foobar"
    end

    test "does not update current user and renders errors when data is invalid", %{conn: conn} do
      conn = put(conn, Routes.user_path(conn, :update), user: %{email: nil})
      assert html_response(conn, 200) =~ "Edit User"
    end

    test "show current user's page", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :show))
      assert html_response(conn, 200) =~ "User Account Setting"
      assert html_response(conn, 200) =~ user.name
    end
  end
end
