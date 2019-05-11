defmodule Api.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :body, :title, :featured_image, :visible, :user_id]}

  schema "posts" do
    field :body, :string
    field :title, :string
    field :featured_image, :string
    field :visible, :boolean
    belongs_to :user, Api.Accounts.User
    has_many :comments, Api.Blog.Comment

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :featured_image, :visible, :user_id])
    |> validate_required([:title, :body, :visible, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
