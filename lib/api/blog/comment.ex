defmodule Api.Blog.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Api.Repo

  @derive {Jason.Encoder, only: [:id, :comment, :name, :post_id]}

  schema "comments" do
    field :comment, :string
    field :name, :string
    belongs_to :post, Api.Blog.Post

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:name, :comment, :post_id])
    |> validate_required([:name, :comment, :post_id])
  end
end
