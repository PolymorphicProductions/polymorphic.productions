defmodule PolymorphicProductionsWeb.PushSubscriberView do
  use PolymorphicProductionsWeb, :view
  alias PolymorphicProductionsWeb.PushSubscriberView

  def render("ok.json", %{push_subscriber: push_subscriber}) do
    %{data: render_one(push_subscriber, PushSubscriberView, "push_subscriber.json")}
  end

  def render("show.json", %{push_subscriber: push_subscriber}) do
    %{data: render_one(push_subscriber, PushSubscriberView, "push_subscriber.json")}
  end

  def render("push_subscriber.json", %{push_subscriber: push_subscriber}) do
    %{
      id: push_subscriber.id,
      endpoint: push_subscriber.endpoint,
      p256dh: push_subscriber.p256dh,
      auth: push_subscriber.auth
    }
  end
end
