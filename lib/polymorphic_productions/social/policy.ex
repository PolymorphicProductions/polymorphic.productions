defmodule PolymorphicProductions.Social.Policy do
  @behaviour Bodyguard.Policy
  alias PolymorphicProductions.Accounts.User

  def authorize(_, %User{admin: true}, _), do: true

  def authorize(_action, _user, _params), do: false
end
