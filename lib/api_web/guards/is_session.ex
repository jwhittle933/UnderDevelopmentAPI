defmodule ApiWeb.Guards do

  defmacro is_session(conn) do
    quote do
      not is_nil(conn)
    end
  end

end