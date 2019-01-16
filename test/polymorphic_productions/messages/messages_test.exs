defmodule PolymorphicProductions.MessagesTest do
  use PolymorphicProductions.DataCase

  alias PolymorphicProductions.Messages

  describe "push_subscriber" do
    alias PolymorphicProductions.Messages.PushSubscriber

    @valid_attrs %{auth: "some auth", endpoint: "some endpoint", p256dh: "some p256dh"}
    @update_attrs %{auth: "some updated auth", endpoint: "some updated endpoint", p256dh: "some updated p256dh"}
    @invalid_attrs %{auth: nil, endpoint: nil, p256dh: nil}

    def push_subscriber_fixture(attrs \\ %{}) do
      {:ok, push_subscriber} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Messages.create_push_subscriber()

      push_subscriber
    end

    test "list_push_subscriber/0 returns all push_subscriber" do
      push_subscriber = push_subscriber_fixture()
      assert Messages.list_push_subscriber() == [push_subscriber]
    end

    test "get_push_subscriber!/1 returns the push_subscriber with given id" do
      push_subscriber = push_subscriber_fixture()
      assert Messages.get_push_subscriber!(push_subscriber.id) == push_subscriber
    end

    test "create_push_subscriber/1 with valid data creates a push_subscriber" do
      assert {:ok, %PushSubscriber{} = push_subscriber} = Messages.create_push_subscriber(@valid_attrs)
      assert push_subscriber.auth == "some auth"
      assert push_subscriber.endpoint == "some endpoint"
      assert push_subscriber.p256dh == "some p256dh"
    end

    test "create_push_subscriber/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_push_subscriber(@invalid_attrs)
    end

    test "update_push_subscriber/2 with valid data updates the push_subscriber" do
      push_subscriber = push_subscriber_fixture()
      assert {:ok, %PushSubscriber{} = push_subscriber} = Messages.update_push_subscriber(push_subscriber, @update_attrs)
      assert push_subscriber.auth == "some updated auth"
      assert push_subscriber.endpoint == "some updated endpoint"
      assert push_subscriber.p256dh == "some updated p256dh"
    end

    test "update_push_subscriber/2 with invalid data returns error changeset" do
      push_subscriber = push_subscriber_fixture()
      assert {:error, %Ecto.Changeset{}} = Messages.update_push_subscriber(push_subscriber, @invalid_attrs)
      assert push_subscriber == Messages.get_push_subscriber!(push_subscriber.id)
    end

    test "delete_push_subscriber/1 deletes the push_subscriber" do
      push_subscriber = push_subscriber_fixture()
      assert {:ok, %PushSubscriber{}} = Messages.delete_push_subscriber(push_subscriber)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_push_subscriber!(push_subscriber.id) end
    end

    test "change_push_subscriber/1 returns a push_subscriber changeset" do
      push_subscriber = push_subscriber_fixture()
      assert %Ecto.Changeset{} = Messages.change_push_subscriber(push_subscriber)
    end
  end
end
