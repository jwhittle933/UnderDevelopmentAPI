defmodule ApiWeb.SubscriptionController do
  use ApiWeb, :controller

  alias Api.Accounts
  alias Api.Accounts.Subscription

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    subscription = Accounts.list_subscription()
    render(conn, "index.json", subscription: subscription)
  end

  def create(conn, %{"subscription" => subscription_params}) do
    with {:ok, %Subscription{} = subscription} <- Accounts.create_subscription(subscription_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.subscription_path(conn, :show, subscription))
      |> render("show.json", subscription: subscription)
    end
  end

  def show(conn, %{"id" => id}) do
    subscription = Accounts.get_subscription!(id)
    render(conn, "show.json", subscription: subscription)
  end

  def update(conn, %{"id" => id, "subscription" => subscription_params}) do
    subscription = Accounts.get_subscription!(id)

    with {:ok, %Subscription{} = subscription} <- Accounts.update_subscription(subscription, subscription_params) do
      render(conn, "show.json", subscription: subscription)
    end
  end

  def delete(conn, %{"id" => id}) do
    subscription = Accounts.get_subscription!(id)

    with {:ok, %Subscription{}} <- Accounts.delete_subscription(subscription) do
      send_resp(conn, :no_content, "")
    end
  end
end
