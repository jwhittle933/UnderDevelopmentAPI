defmodule Api.Accounts.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :email]}

  schema "subscriptions" do
    field :email, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:name, :email])
    |> validate_required([:email])
  end
end
