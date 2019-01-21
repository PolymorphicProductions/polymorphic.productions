defmodule PolymorphicProductions.BillingTest do
  use PolymorphicProductions.DataCase

  alias PolymorphicProductions.Billing

  describe "charges" do
    alias PolymorphicProductions.Billing.Charge

    @valid_attrs %{strip_id: "some strip_id"}
    @update_attrs %{strip_id: "some updated strip_id"}
    @invalid_attrs %{strip_id: nil}

    def charge_fixture(attrs \\ %{}) do
      {:ok, charge} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Billing.create_charge()

      charge
    end

    test "list_charges/0 returns all charges" do
      charge = charge_fixture()
      assert Billing.list_charges() == [charge]
    end

    test "get_charge!/1 returns the charge with given id" do
      charge = charge_fixture()
      assert Billing.get_charge!(charge.id) == charge
    end

    test "create_charge/1 with valid data creates a charge" do
      assert {:ok, %Charge{} = charge} = Billing.create_charge(@valid_attrs)
      assert charge.strip_id == "some strip_id"
    end

    test "create_charge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Billing.create_charge(@invalid_attrs)
    end

    test "update_charge/2 with valid data updates the charge" do
      charge = charge_fixture()
      assert {:ok, %Charge{} = charge} = Billing.update_charge(charge, @update_attrs)
      assert charge.strip_id == "some updated strip_id"
    end

    test "update_charge/2 with invalid data returns error changeset" do
      charge = charge_fixture()
      assert {:error, %Ecto.Changeset{}} = Billing.update_charge(charge, @invalid_attrs)
      assert charge == Billing.get_charge!(charge.id)
    end

    test "delete_charge/1 deletes the charge" do
      charge = charge_fixture()
      assert {:ok, %Charge{}} = Billing.delete_charge(charge)
      assert_raise Ecto.NoResultsError, fn -> Billing.get_charge!(charge.id) end
    end

    test "change_charge/1 returns a charge changeset" do
      charge = charge_fixture()
      assert %Ecto.Changeset{} = Billing.change_charge(charge)
    end
  end
end
