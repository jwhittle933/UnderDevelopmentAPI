defmodule Api.Blog.Reply do
  use Ecto.Schema
  import Ecto.Changeset

  schema "replies" do
    field :comment, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(reply, attrs) do
    reply
    |> cast(attrs, [:comment, :name])
    |> validate_required([:comment, :name])
  end
end
