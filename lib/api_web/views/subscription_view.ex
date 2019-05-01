defmodule ApiWeb.SubscriptionView do
  use ApiWeb, :view
  alias ApiWeb.SubscriptionView

  def render("index.json", %{subscription: subscription}) do
    %{data: render_many(subscription, SubscriptionView, "subscription.json")}
  end

  def render("show.json", %{subscription: subscription}) do
    %{data: render_one(subscription, SubscriptionView, "subscription.json")}
  end

  def render("subscription.json", %{subscription: subscription}) do
    %{id: subscription.id,
      name: subscription.name,
      email: subscription.email}
  end
end
