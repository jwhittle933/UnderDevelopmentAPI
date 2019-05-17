defmodule Api.Blog do
  @moduledoc """
  The Blog context.
  """

  @doc """
  __using__() imports Context Fragments and injects them for use.

  In the using Module, these Context methods will be exposed like
  any other import statement, without reference to the Module name.

  If you'd rather use ModuleName.function in your using Module, change
  the following imports to alias.
  """

  defmacro __using__(_) do
    quote do
      import Api.Blog.Fragments.Posts
      import Api.Blog.Fragments.Comments
      import Api.Blog.Fragments.Drafts
      import Api.Blog.Fragments.Replies
    end
  end
end
