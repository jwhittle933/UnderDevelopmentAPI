defmodule ApiWeb.Plug.Authenticate do 
  import Plug.Conn
  alias Api.Accounts

  def init(params), do: params

  def call(conn, _params) do
    with {:ok, current_user_id} <- Plug.Conn.get_session(conn, :current_user_id),
      {:ok, user} <- Accounts.get_user!(current_user_id) do
      conn
      |> set_current_user(user)
    else
      :error ->
        conn
        |> put_status(:unauthorized)
        |> put_resp_header("content-type", "application/json")
        |> send_resp(401, %{code: 401, message: "Unauthorized"})
        |> halt
    end
  end

  defp set_current_user(conn, %{"id" => id, "name" => name} = user) do
    conn
    |> assign(:current_user, user)
    |> assign(:user_signed_in?, true)
  end
  
end
