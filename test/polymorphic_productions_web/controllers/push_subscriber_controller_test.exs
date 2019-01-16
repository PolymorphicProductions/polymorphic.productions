defmodule PolymorphicProductionsWeb.PushSubscriberControllerTest do
  use PolymorphicProductionsWeb.ConnCase

  alias PolymorphicProductions.Messages
  alias PolymorphicProductions.Messages.PushSubscriber

  @create_attrs %{
    auth: "some auth",
    endpoint: "some endpoint",
    p256dh: "some p256dh"
  }
  @update_attrs %{
    auth: "some updated auth",
    endpoint: "some updated endpoint",
    p256dh: "some updated p256dh"
  }
  @invalid_attrs %{auth: nil, endpoint: nil, p256dh: nil}

  def fixture(:push_subscriber) do
    {:ok, push_subscriber} = Messages.create_push_subscriber(@create_attrs)
    push_subscriber
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all push_subscriber", %{conn: conn} do
      conn = get(conn, Routes.push_subscriber_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create push_subscriber" do
    test "renders push_subscriber when data is valid", %{conn: conn} do
      conn = post(conn, Routes.push_subscriber_path(conn, :create), push_subscriber: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.push_subscriber_path(conn, :show, id))

      assert %{
               "id" => id,
               "auth" => "some auth",
               "endpoint" => "some endpoint",
               "p256dh" => "some p256dh"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.push_subscriber_path(conn, :create), push_subscriber: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update push_subscriber" do
    setup [:create_push_subscriber]

    test "renders push_subscriber when data is valid", %{conn: conn, push_subscriber: %PushSubscriber{id: id} = push_subscriber} do
      conn = put(conn, Routes.push_subscriber_path(conn, :update, push_subscriber), push_subscriber: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.push_subscriber_path(conn, :show, id))

      assert %{
               "id" => id,
               "auth" => "some updated auth",
               "endpoint" => "some updated endpoint",
               "p256dh" => "some updated p256dh"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, push_subscriber: push_subscriber} do
      conn = put(conn, Routes.push_subscriber_path(conn, :update, push_subscriber), push_subscriber: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete push_subscriber" do
    setup [:create_push_subscriber]

    test "deletes chosen push_subscriber", %{conn: conn, push_subscriber: push_subscriber} do
      conn = delete(conn, Routes.push_subscriber_path(conn, :delete, push_subscriber))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.push_subscriber_path(conn, :show, push_subscriber))
      end
    end
  end

  defp create_push_subscriber(_) do
    push_subscriber = fixture(:push_subscriber)
    {:ok, push_subscriber: push_subscriber}
  end
end
