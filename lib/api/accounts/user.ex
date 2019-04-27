defmodule Api.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bcrypt

  @derive {Jason.Encoder, only: [:email, :name, :password_hash, :admin]}

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :admin, :boolean
    has_many :posts, Api.Blog.Post
    has_many :comments, Api.Blog.Comment # subject to change

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :admin])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> validate_required([:name, :email, :password, :admin])
    |> hash
  end


  defp hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    # Bycrypt.add_hash/1 intakes string returns a map 
    %{password_hash: password_hash} = Bcrypt.add_hash(password)
    change(changeset, password_hash: password_hash)
  end

  defp hash(changeset), do: changeset


end
