defmodule ApiWeb.AuthControllerTest do
  import Plug.Test
  use ApiWeb.ConnCase
  alias Plug.Conn

  @valid %{email: "test@test.com", password: "testuser"}
  @invalid %{email: "not_a_user@fail.com", password: "failure"}
  @wrong_pass %{email: "test@test.com", password: "wrongpass"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "Login" do
    test "Login with valid credentials puts session on connection", %{conn: conn} do
      resp =
        conn
        |> post(Routes.auth_path(conn, :login, @valid))

      msg = get_msg(resp)
      assert msg == "Authenticated."
      assert Conn.get_session(resp, :current_user_id) == 205
    end

    test "Login with invalid email" do
      resp =
        conn
        |> post(Routes.auth_path(conn, :login, @invalid))

      msg = get_msg(resp)
      assert msg == "Couldn't find a user with that email."
    end

    test "Login with valid email and wrong password" do
      resp =
        conn
        |> post(Routes.auth_path(conn, :login, @wrong_pass))

      msg = get_msg(resp)
      assert msg == "Unauthorized. The email and password do not match."
    end
  end

  describe "Logout" do
    test "Logout drops session", %{conn: conn} do
      resp =
        conn
        |> init_test_session(current_user_id: 100)
        |> get(Routes.auth_path(conn, :logout))

      %{current_user: current_user, user_signed_in?: signed_in?} = resp.assigns
      assert current_user == nil
      assert signed_in? == false
      refute get_session(resp, :current_user_id)
    end
  end

  defp get_msg(resp) do
    {:ok, resp_body} = resp.resp_body |> Poison.decode()
    resp_body["msg"]
  end
end
