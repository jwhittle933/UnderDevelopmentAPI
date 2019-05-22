defmodule ApiWeb.Guards do
  defmacro is_session(conn) do
    quote do
      not is_nil(conn.assigns.current_user_id) and conn.assigns.user_signed_in? == true
    end
  end
end
