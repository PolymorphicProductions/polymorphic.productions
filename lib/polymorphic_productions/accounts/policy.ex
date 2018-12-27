defmodule PolymorphicProductions.Accounts.Policy do
  @behaviour Bodyguard.Policy

  def authorize(_action, %{admin: true}, _params), do: true
  def authorize(_action, _user, _params), do: false
end
