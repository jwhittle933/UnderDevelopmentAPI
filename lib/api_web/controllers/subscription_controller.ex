defmodule ApiWeb.SubscriptionController do
  use ApiWeb, :controller

  use Api.Accounts
  alias Api.Accounts.Subscription

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    subscriptions = list_subscription()

    conn
    |> json(%{subscriptions: subscriptions})
  end

  def create(conn, %{"subscription" => subscription_params}) do
    with {:ok, %Subscription{} = subscription} <- create_subscription(subscription_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.subscription_path(conn, :show, subscription))
      |> json(%{subscription: subscription, msg: "Thanks for subscribing."})
    end
  end

  def show(conn, %{"id" => id}) do
    subscription = get_subscription!(id)

    conn
    |> json(%{subscription: subscription})
  end

  def update(conn, %{"id" => id, "subscription" => subscription_params}) do
    subscription = get_subscription!(id)

    with {:ok, %Subscription{} = subscription} <-
           update_subscription(subscription, subscription_params) do
      conn |> json(%{subscription: subscription})
    end
  end

  def delete(conn, %{"id" => id}) do
    subscription = get_subscription!(id)

    with {:ok, %Subscription{}} <- delete_subscription(subscription) do
      send_resp(conn, :no_content, "")
    end
  end
end
