defmodule PolymorphicProductionsWeb.PageControllerTest do
  use PolymorphicProductionsWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Your personal creative digital metamorphosis"
  end

  test "GET /privacy", %{conn: conn} do
    conn = get(conn, "/privacy")
    assert html_response(conn, 200) =~ "Privacy Policy"
  end

  test "GET /terms", %{conn: conn} do
    conn = get(conn, "/terms")
    assert html_response(conn, 200) =~ "Terms and Conditions"
  end

  test "GET /about", %{conn: conn} do
    conn = get(conn, "/about")
    assert html_response(conn, 200) =~ "About Me"
  end

  test "GET /contact", %{conn: conn} do
    conn = get(conn, "/contact")
    assert html_response(conn, 200) =~ "Contact Me"
  end

  test "GET /sessions/new", %{conn: conn} do
    conn = get(conn, "/sessions/new")
    assert html_response(conn, 200) =~ "Enter your login"
  end

  test "GET /password_resets/new", %{conn: conn} do
    conn = get(conn, "/password_resets/new")
    assert html_response(conn, 200) =~ "Recover your Account"
  end

  test "GET /signup", %{conn: conn} do
    conn = get(conn, "signup")
    assert html_response(conn, 200) =~ "Registration"
  end
end
