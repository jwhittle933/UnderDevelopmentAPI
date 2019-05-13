defmodule ApiWeb.AuthenticatePlugTest do
  use ApiWeb.ConnCase
  import Plug.Conn
  import Plug.Test


  @valid %{email: "test@test.com", password: "testuser", id: 205}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "Authenticate Plug" do
    test "User info is assigned with authentication", %{conn: conn} do
     {user, signed_in?} =
        conn
        |> init_test_session(current_user_id: 205)
        |> ApiWeb.Plug.Authenticate.call(%{})
        |> get_changed_fields

      refute is_nil(user.name)
      refute is_nil(user.id)
      assert signed_in?

    end

    test "401 When no session", %{conn: conn} do
      resp =
        conn
        |> init_test_session(invalid_field: 2000)
        |> ApiWeb.Plug.Authenticate.call(%{})

      assert resp.status == 401
      assert resp.assigns == %{}
    end


    test "401 when session contains invalied user id" do
      resp =
        conn
        |> init_test_session(current_user_id: 2000)
        |> ApiWeb.Plug.Authenticate.call(%{})

      assert resp.status == 401
      assert resp.assigns == %{}
    end
  end

  defp get_changed_fields(conn) do
    %{current_user: user, user_signed_in?: signed_in?} = conn.assigns
    {user, signed_in?}
  end

end
