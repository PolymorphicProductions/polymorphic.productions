defmodule PolymorphicProductions.Messages.Policy do
  @behaviour Bodyguard.Policy

  def authorize(_action, _user, _params), do: true
end
