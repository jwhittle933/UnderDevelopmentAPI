defmodule Api.Blog.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:comment, :name, :user, :post]}

  schema "comments" do
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
    |> cast_assoc(:user)
    |> cast_assoc(:post)
    |> validate_required([:name, :comment, :user, :post])
  end
end
