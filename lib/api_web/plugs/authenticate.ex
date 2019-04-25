defmodule ApiWeb.Plugs.Authenticate do 
  import Plug.Conn

  def init(_params) do
  end

  def call(conn, _params) do

    with {:ok, _user_id} <- Plug.Conn.get_session(conn, :current_user_id) do
      conn
    else
      :error ->
        conn
        |> put_status(:not_allowed)
        |> put_resp_header("content-type", "application/json")
        |> send_resp(401, %{code: 401, message: "Unauthorized user."})
    end
  end
  
end
