defmodule Api.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bcrypt

  @derive {Jason.Encoder, only: [:id, :email, :name, :password_hash, :admin, :bio]}

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :admin, :boolean
    field :bio, :string
    has_many :posts, Api.Blog.Post

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :admin, :bio])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> validate_required([:name, :email, :password, :admin])
    |> hash
  end


  defp hash(%Ecto.Changeset{valid?: true, changes: 
    %{password: password}} = changeset) do
    # Bycrypt.add_hash/1 intakes string returns a map 
    %{password_hash: password_hash} = Bcrypt.add_hash(password)
    change(changeset, password_hash: password_hash)
  end

  defp hash(changeset), do: changeset


end
