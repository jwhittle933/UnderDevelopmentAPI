defmodule ApiWeb.AuthController do
  use ApiWeb, :controller

  alias Api.Accounts
  alias Bcrypt


  @doc """
    Session checks should be done on the client before ever
    hitting the api. If no session, client should redirect to 
    login view. 
    login/1 checks for session regardless
  """
  def login(conn, %{email: email, password: password}) when is_nil(password) or is_nil(email) do
    conn
    |> insufficient_data
  end

  def login(conn, %{email: email, password: password}) do
    with {:ok, user} <- Accounts.get_user_by!(email),
      true <- Bcrypt.verify_pass(password, user.password_hash) do
        # If user is already logged in: configure_session(conn, renew: true)
        # If user is not logged in, with valid credentials: put_session(conn, :current_user_id, id)
        # conn
        # |> configure_session(renew: true)
        conn
        |> put_session(:current_user_id, user.id)
    end
  end
 
  
  defp add_pass(user, password) do
    Map.put(user, :password, password)
  end

  def logout(conn, _params) do
    # Plug.Conn.clear_session/1
  end

  defp insufficient_data(conn) do
    conn
    |> put_status(:bad_request)
    |> put_resp_header("content-type", "application/json")
    |> send_resp(400, %{message: "Insufficient data supplied"})
  end

end