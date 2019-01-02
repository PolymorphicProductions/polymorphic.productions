defmodule PolymorphicProductions.Utils.Guards do
  defmacro is_blank(nil) do
    quote do: true
  end

  defmacro is_blank(something) when something == "" do
    quote do: true
  end

  defmacro is_blank(_) do
    quote do: false
  end
end
