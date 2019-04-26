defmodule Api.Blog.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:comment, :name, :user]}

  schema "comment" do
    field :comment, :string
    field :name, :string
    belongs_to :user, Api.Accounts.User
    belongs_to :post, Api.Blog.Post

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:name, :comment])
    |> validate_required([:name, :comment])
  end
end
