defmodule Api.Accounts do

  @moduledoc """
  The Accounts context module.

  __using__() imports Context Fragments and injects them for use.

  In the using Module, these Context methods will be exposed like
  any other import statement, without reference to the Module name.

  If you'd rather use ModuleName.function in your using Module, change
  the following imports to aliases.

  """

  defmacro __using__(_) do
    quote do
      import Api.Accounts.Fragments.Users
      import Api.Accounts.Fragments.Subscriptions
    end
  end
end
