defmodule ApiWeb.SubscriptionControllerTest do
  use ApiWeb.ConnCase

  use Api.Accounts
  import ApiWeb.Helpers
  alias Api.Accounts.Subscription
  alias Plug.Conn

  @create_attrs %{
    email: "some email",
    name: "some name"
  }
  @update_attrs %{
    email: "some updated email",
    name: "some updated name"
  }
  @invalid_attrs %{email: nil, name: nil}

  def fixture(:subscription) do
    subscription = create_subscription(@create_attrs)
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all subscription", %{conn: conn} do
      {:ok, subscription} = fixture(:subscription)

      %{"subscriptions" => subscriptions} =
        conn
        |> get(Routes.subscription_path(conn, :index))
        |> get_resp_body

      assert subscriptions |> List.first() |> Map.fetch("email") == {:ok, "some email"}
      assert subscriptions |> List.first() |> Map.fetch("name") == {:ok, "some name"}
      refute :error == subscriptions |> List.first() |> Map.fetch("id")
    end
  end

  describe "create subscription" do
    test "renders subscription when data is valid", %{conn: conn} do
      resp =
        conn
        |> post(Routes.subscription_path(conn, :create), subscription: @create_attrs)
        |> get_resp_body

      assert resp["msg"] == "Thanks for subscribing."

      assert %{
               "id" => id,
               "email" => "some email",
               "name" => "some name"
             } = resp["subscription"]

      %{"subscription" => subscription} =
        conn
        |> get(Routes.subscription_path(conn, :show, id))
        |> get_resp_body

      assert %{
               "id" => id,
               "email" => "some email",
               "name" => "some name"
             } = subscription
    end

    test "renders errors when data is invalid", %{conn: conn} do
      %{"errors" => errors} =
        conn
        |> post(Routes.subscription_path(conn, :create), subscription: @invalid_attrs)
        |> get_resp_body

      assert errors != %{}
    end
  end

  describe "update subscription" do
    setup [:new_subscription]

    test "renders subscription when data is valid", %{
      conn: conn,
      subscription: %Subscription{id: id} = subscription
    } do
      %{"subscription" => %{"id" => subscription_id}} =
        conn
        |> put(Routes.subscription_path(conn, :update, subscription), subscription: @update_attrs)
        |> get_resp_body

      assert id == subscription_id

      %{"subscription" => subscription} =
        conn
        |> get(Routes.subscription_path(conn, :show, id))
        |> get_resp_body

      assert %{
               "id" => ^id,
               "email" => "some updated email",
               "name" => "some updated name"
             } = subscription
    end

    test "renders errors when data is invalid", %{conn: conn, subscription: subscription} do
      %{"errors" => errors} =
        conn
        |> put(Routes.subscription_path(conn, :update, subscription), subscription: @invalid_attrs)
        |> get_resp_body

      assert errors != %{}
    end
  end

  describe "delete subscription" do
    setup [:new_subscription]

    test "deletes chosen subscription", %{conn: conn, subscription: subscription} do
      conn = delete(conn, Routes.subscription_path(conn, :delete, subscription))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.subscription_path(conn, :show, subscription))
      end
    end
  end

  defp new_subscription(_) do
    {:ok, subscription} = fixture(:subscription)
    [subscription: subscription]
  end
end
