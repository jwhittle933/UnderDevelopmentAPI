defmodule Api.Blog.Reply do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :reply, :name, :comment_id]}

  schema "replies" do
    field :reply, :string
    field :name, :string
    belongs_to :comment, Api.Blog.Comment

    timestamps()
  end

  @doc false
  def changeset(reply, attrs) do
    reply
    |> cast(attrs, [:reply, :name, :comment_id])
    |> validate_required([:comment_id, :reply, :name])
  end
end
