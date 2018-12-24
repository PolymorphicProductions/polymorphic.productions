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
      assert html_response(conn, 200) =~ "New User"
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
      assert html_response(conn, 200) =~ "New User"
      assert html_response(conn, 200) =~ "Please check the errors below."
    end

    test "redirects guest to login when visiting User index", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "redirects guest to login when visiting User show", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :show, 1))
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "redirects guest to login when visiting User edit", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :edit, 1))
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "redirects guest to login when visiting User update", %{conn: conn} do
      conn = put(conn, Routes.user_path(conn, :update, 1))
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "redirects guest to login when visiting User delete", %{conn: conn} do
      conn = delete(conn, Routes.user_path(conn, :delete, 1))
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end
  end

  describe "authed user" do
    setup [:log_user_in, :create_rando_user]

    test "renders form for editing current user", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "Edit User"
    end

    test "does not renders form for editing different user", %{
      conn: conn,
      user: _user,
      rando: rando
    } do
      conn = get(conn, Routes.user_path(conn, :edit, rando))
      redirect_path = Routes.page_path(conn, :index)
      assert redirect_path == redirected_to(conn, 302)

      conn = get(recycle(conn), redirect_path)
      assert html_response(conn, 200) =~ "You are not authorized to view this page"
    end

    @tag skip: "TODO"
    test "updates chosen user when data is valid", %{conn: _conn} do
    end

    @tag skip: "TODO"
    test "does not update chosen user and renders errors when data is invalid", %{conn: _conn} do
    end

    @tag skip: "TODO"
    test "show current user's page", %{conn: _conn} do
    end

    @tag skip: "TODO"
    test "deletes current user", %{conn: _conn} do
    end

    @tag skip: "TODO"
    test "cannot delete other user", %{conn: _conn} do
    end
  end

  describe "authed admin" do
    @tag skip: "TODO"
    test "renders form for editing any user", %{conn: _conn} do
    end

    @tag skip: "TODO"
    test "updates any user when data is valid", %{conn: _conn} do
    end

    @tag skip: "TODO"
    test "does not update any user and renders errors when data is invalid", %{conn: _conn} do
    end

    @tag skip: "TODO"
    test "show any user's page", %{conn: _conn} do
    end

    @tag skip: "TODO"
    test "deletes any user", %{conn: _conn} do
    end
  end
end
