defmodule PolymorphicProductionsWeb.ChargeController do
  use PolymorphicProductionsWeb, :controller

  alias PolymorphicProductions.Billing
  alias PolymorphicProductions.Billing.Charge

  def index(conn, _params) do
    charges = Billing.list_charges()
    render(conn, "index.html", charges: charges)
  end

  def new(%{assigns: %{current_user: current_user}} = conn, _params) do
    changeset = Billing.change_charge(%Charge{})
    render(conn, "new.html", changeset: changeset, current_user: current_user)
  end

  def create(%{assigns: %{current_user: current_user}} = conn, %{"charge" => charge_params}) do
    case Billing.create_charge(current_user, charge_params) do
      {:ok, charge} ->
        conn
        |> put_flash(:info, "Charge created successfully.")
        |> redirect(to: Routes.charge_path(conn, :show, charge))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    charge = Billing.get_charge!(id)
    render(conn, "show.html", charge: charge)
  end

  def edit(conn, %{"id" => id}) do
    charge = Billing.get_charge!(id)
    changeset = Billing.change_charge(charge)
    render(conn, "edit.html", charge: charge, changeset: changeset)
  end

  def update(conn, %{"id" => id, "charge" => charge_params}) do
    charge = Billing.get_charge!(id)

    case Billing.update_charge(charge, charge_params) do
      {:ok, charge} ->
        conn
        |> put_flash(:info, "Charge updated successfully.")
        |> redirect(to: Routes.charge_path(conn, :show, charge))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", charge: charge, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    charge = Billing.get_charge!(id)
    {:ok, _charge} = Billing.delete_charge(charge)

    conn
    |> put_flash(:info, "Charge deleted successfully.")
    |> redirect(to: Routes.charge_path(conn, :index))
  end
end
