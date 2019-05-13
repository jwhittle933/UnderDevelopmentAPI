defmodule ApiWeb.AuthenticatePlugTest do
  use ApiWeb.ConnCase


  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "Authenticate Plug" do
    test "User info is assigned with authentication", %{conn: conn} do

    end

    test "401 When user is unauthenticated", %{conn: conn} do

    end
  end
end
