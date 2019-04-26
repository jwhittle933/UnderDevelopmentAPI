defmodule Api.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:email, :name, :password, :admin, :posts, :comments]}

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :admin, :boolean
    has_many :posts, Api.Blog.Post
    has_many :comments, Api.Blog.Comment

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :admin])
    |> validate_required([:name, :email, :password_hash, :admin])
  end
end
