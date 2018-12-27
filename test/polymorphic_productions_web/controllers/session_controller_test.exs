defmodule PolymorphicProductionsWeb.SessionControllerTest do
  use PolymorphicProductionsWeb.ConnCase

  import PolymorphicProductionsWeb.AuthCase

  @create_attrs %{email: "robin@example.com", password: "reallyHard2gue$$", name: "foobar"}
  @invalid_attrs %{email: "robin@example.com", password: "cannotGue$$it", name: "foobar"}
  @unconfirmed_attrs %{
    email: "lancelot@example.com",
    password: "reallyHard2gue$$",
    name: "foobar"
  }
  @rem_attrs %{
    email: "robin@example.com",
    password: "reallyHard2gue$$",
    remember_me: "true",
    name: "foobar"
  }
  @no_rem_attrs Map.merge(@rem_attrs, %{remember_me: "false"})

  setup %{conn: conn} do
    conn = conn |> bypass_through(PolymorphicProductionsWeb.Router, [:browser]) |> get("/")
    add_user("lancelot@example.com", "foobar")
    user = add_user_confirmed("robin@example.com", "foobar")
    {:ok, %{conn: conn, user: user}}
  end

  describe "login form" do
    test "redirects to home page fo users that are already logged in", %{
      conn: conn,
      user: user
    } do
      conn = conn |> add_session(user) |> send_resp(:ok, "/")
      conn = get(conn, Routes.session_path(conn, :new))
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  describe "create session" do
    test "login succeeds", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), session: @create_attrs)
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "login fails for user that is not yet confirmed", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), session: @unconfirmed_attrs)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "login fails for user that is already logged in", %{conn: conn, user: user} do
      conn = conn |> add_session(user) |> send_resp(:ok, "/")
      conn = post(conn, Routes.session_path(conn, :create), session: @create_attrs)
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "login fails for invalid password", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), session: @invalid_attrs)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "redirects to previously requested resource", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :show))
      assert redirected_to(conn) == Routes.session_path(conn, :new)
      conn = post(conn, Routes.session_path(conn, :create), session: @create_attrs)
      assert redirected_to(conn) == Routes.user_path(conn, :show)
    end

    test "remember me cookie is added / not added", %{conn: conn} do
      rem_conn = post(conn, Routes.session_path(conn, :create), session: @rem_attrs)
      assert rem_conn.resp_cookies["remember_me"]
      no_rem_conn = post(conn, Routes.session_path(conn, :create), session: @no_rem_attrs)
      refute no_rem_conn.resp_cookies["remember_me"]
    end
  end

  describe "delete session" do
    test "logout succeeds and session is deleted", %{conn: conn, user: user} do
      conn = conn |> add_session(user) |> send_resp(:ok, "/")
      conn = delete(conn, Routes.session_path(conn, :delete, user))
      assert redirected_to(conn) == Routes.page_path(conn, :index)
      conn = get(conn, Routes.user_path(conn, :show))
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end
  end
end
