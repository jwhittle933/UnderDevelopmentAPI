defmodule ApiWeb.AuthController do
  use ApiWeb, :controller

  alias Api.Accounts
  alias Api.Accounts.User
  import Bcrypt, only: [verify_pass: 2]


  @doc """
    Session checks should be done on the client before ever
    hitting the api. If no session, client should redirect to
    login view.
  """
  def login(conn, %{"email" => email, "password" => password}) do
    with %User{} = user <- Accounts.get_user_by(email),
      true <- verify_pass(password, user.password_hash) do
        conn
        |> put_session(:current_user_id, user.id)
        |> json(%{msg: "Authenticated."})
    else
      nil ->
        conn
        |> put_status(:bad_request)
        |> put_resp_header("content-type", "application/json")
        |> json(%{msg: "Couldn't find a user with that email."})
      _ ->
        conn
        |> put_status(:unauthorized)
        |> put_resp_header("content-type", "application/json")
        |> json(%{msg: "Unauthorized. The email and password do not match."})

    end
  end

  def login(conn, _params), do: conn |> insufficient_data

  def logout(conn, _params) do
    conn
    |> Plug.Conn.configure_session(drop: true)
    |> assign(:current_user, nil)
    |> assign(:user_signed_in?, false)
  end

  defp insufficient_data(conn) do
    conn
    |> put_status(:bad_request)
    |> send_resp(400, "You must supply valid credentials.")
  end

end
