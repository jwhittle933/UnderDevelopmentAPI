defmodule ApiWeb.AuthController do
  use ApiWeb, :controller


  def login(conn, _params) do
    # 
  end

  def logout(conn, _params) do
    # 
  end


  defp authenticate_user(conn, _params) do
    if conn.assigns.user_signed_in? do
      conn
    else
      conn 
    end
  end

end