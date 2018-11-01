defmodule PolymorphicProductionsWeb.Auth.Token do
  @behaviour Phauxth.Token
  alias Phoenix.Token
  alias PolymorphicProductionsWeb.Endpoint

  @max_age 14_400
  @token_salt "5W3bQee3"

  @impl true
  def sign(data, opts \\ []) do
    Token.sign(Endpoint, @token_salt, data, opts)
  end

  @impl true
  def verify(token, opts \\ []) do
    Token.verify(Endpoint, @token_salt, token, opts ++ [max_age: @max_age])
  end
end
