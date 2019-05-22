defmodule Api.Blog do
  @moduledoc """
  The Blog context module.

  __using__ imports Context Fragments and injects them for use.

  In the using Module, these Context methods will be exposed like
  any other import statement, without reference to the Module name.

  If you'd rather use ModuleName.function in your using Module, change
  the following imports to aliases.
  """

  def posts do
    quote do
      import Api.Blog.Fragments.Posts
    end
  end

  def comments do
    quote do
      import Api.Blog.Fragments.Comments
    end
  end

  def drafts do
    quote do
      import Api.Blog.Fragments.Drafts
    end
  end

  def replies do
    quote do
      import Api.Blog.Fragments.Replies
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  defmacro __using__(_) do
    quote do
      import Api.Blog.Fragments.Posts
      import Api.Blog.Fragments.Comments
      import Api.Blog.Fragments.Drafts
      import Api.Blog.Fragments.Replies
    end
  end
end
