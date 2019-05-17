defmodule Api.Accounts do
  @moduledoc """
  The Accounts context.
  """

  @doc """
  Context Fragment imports
  """

  defmacro __using__(_) do
    quote do
      import Api.Accounts.Fragments.Users
      import Api.Accounts.Fragments.Subscriptions
    end
  end


end
