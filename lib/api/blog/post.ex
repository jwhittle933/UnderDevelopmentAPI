defmodule Api.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:body, :title]}

  schema "posts" do
    field :body, :string
    field :title, :string
    field :featured_image, :string
    belongs_to :user, Api.Accounts.User
    has_many :comments, Api.Blog.Comment

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :featured_image])
    |> validate_required([:title, :body])
  end
end
