defmodule Api.Blog.Draft do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:title, :body, :featured_image]}

  schema "drafts" do
    field :body, :string
    field :title, :string
    field :featured_image, :string
    belongs_to :user, Api.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(draft, attrs) do
    draft
    |> cast(attrs, [:body, :title, :featured_image])
    |> validate_required([:body, :title])
  end
end
