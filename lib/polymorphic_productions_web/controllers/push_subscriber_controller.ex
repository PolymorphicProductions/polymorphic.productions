defmodule PolymorphicProductionsWeb.PushSubscriberController do
  use PolymorphicProductionsWeb, :controller

  alias PolymorphicProductions.Messages
  alias PolymorphicProductions.Messages.PushSubscriber

  # action_fallback(PolymorphicProductionsWeb.FallbackController)

  def create(conn, %{"subscription" => push_subscriber_params}) do
    with {:ok, %PushSubscriber{} = push_subscriber} <-
           Messages.create_push_subscriber(push_subscriber_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", Routes.push_subscriber_path(conn, :show, push_subscriber))
      |> render("ok.json", push_subscriber: push_subscriber)
    end
  end

  def delete(conn, %{"id" => id}) do
    push_subscriber = Messages.get_push_subscriber!(id)

    with {:ok, %PushSubscriber{}} <- Messages.delete_push_subscriber(push_subscriber) do
      send_resp(conn, :no_content, "")
    end
  end
end
