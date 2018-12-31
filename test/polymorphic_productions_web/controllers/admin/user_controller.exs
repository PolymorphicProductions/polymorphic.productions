defmodule PolymorphicProductionsWeb.Admin.UserControllerTest do
  use PolymorphicProductionsWeb.ConnCase

  import PolymorphicProductions.Factory
  import PolymorphicProductionsWeb.AuthCase

  @create_attrs params_for(:user)

  setup %{conn: conn} do
    conn = conn |> bypass_through(PolymorphicProductionsWeb.Router, [:browser]) |> get("/")
    {:ok, %{conn: conn}}
  end

  describe "authed admin" do
    setup [:log_admin_in, :create_rando_user]

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
