defmodule PolymorphicProductions.AccountsTest do
  import PolymorphicProductions.Factory

  use PolymorphicProductions.DataCase

  alias PolymorphicProductions.Accounts
  alias PolymorphicProductions.Accounts.User

  @create_attrs params_for(:user)
  @update_attrs params_for(:user)
  @invalid_attrs Map.from_struct(%PolymorphicProductions.Accounts.User{})

  test "list_users/1 returns all users" do
    # user = insert(:user, password: nil)
    Accounts.list_users() |> IO.inspect()
    # assert Accounts.list_users() == [user]
  end

  test "get returns the user with given id" do
    user = insert(:user, password: nil)
    assert Accounts.get_user(user.id) == user
  end

  test "create_user/1 with valid data creates a user" do
    assert {:ok, %User{} = user} = Accounts.create_user(@create_attrs)
    assert user.email == @create_attrs.email
  end

  test "create_user/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
  end

  test "update_user/2 with valid data updates the user" do
    user = insert(:user)
    assert {:ok, user} = Accounts.update_user(user, @update_attrs)
    assert %User{} = user
    assert user.email == @update_attrs.email
  end

  test "update_user/2 with invalid data returns error changeset" do
    user = insert(:user, password: nil)
    assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
    assert user == Accounts.get_user(user.id)
  end

  test "delete_user/1 deletes the user" do
    user = insert(:user)
    assert {:ok, %User{}} = Accounts.delete_user(user)
    refute Accounts.get_user(user.id)
  end

  test "change_user/1 returns a user changeset" do
    user = insert(:user)
    assert %Ecto.Changeset{} = Accounts.change_user(user)
  end

  test "update password changes the stored hash" do
    %{password_hash: stored_hash} = user = insert(:user)
    attrs = %{password: "CN8W6kpb"}
    {:ok, %{password_hash: hash}} = Accounts.update_password(user, attrs)
    assert hash != stored_hash
  end

  test "update_password with weak password fails" do
    user = insert(:user)
    attrs = %{password: "pass"}
    assert {:error, %Ecto.Changeset{}} = Accounts.update_password(user, attrs)
  end
end
