defmodule ApiWeb.Helpers.ErrorEncode do

  def get_errors(acc, [head | tail]) do
    {atom, value} = head
    {msg, _} = value
    Map.put(acc, Atom.to_string(atom), msg)
    |> get_errors(tail)
  end

  def get_errors(acc, []) do
    Poison.encode!(acc)
  end

end
