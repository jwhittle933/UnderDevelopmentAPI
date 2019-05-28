defmodule Api.Blog.Fragments.Replies do
  import Ecto.Changeset
  import Ecto.Query
  alias Api.Repo
  alias Api.Blog.Reply

  @doc """
  Returns the list of replies associated with a specific comment.

  THIS METHOD MAY NOT BE USED. FETCHING COMMENTS SHOULD ALSO PRELOAD
  REPLIES. AN ALTERNATIVE IS TO ONLY SHOW COMMENTS ON THE CLIENT, UNLESS
  A USER REQUESTS REPLIES.

  ## Examples

      iex> list_replies()
      [%Reply{}, ...]

  """
  def list_replies(comment_id) do
    query = from r in Reply, where: r.comment_id == comment_id
    Repo.all(query)
  end

  @doc """
  Gets a single reply. WILL LIKELY NEVER BE USED.

  Raises `Ecto.NoResultsError` if the Reply does not exist.

  ## Examples

      iex> get_reply!(123)
      %Reply{}

      iex> get_reply!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reply!(id), do: Repo.get!(Reply, id)

  @doc """
  Creates a reply. CREATING REPLY WILL NEED A WAY TO TRACK THE CREATOR. IP?

  ## Examples

      iex> create_reply(%{field: value})
      {:ok, %Reply{}}

      iex> create_reply(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reply(attrs \\ %{}) do
    %Reply{}
    |> Reply.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reply. UPDATING REPLIES WILL REQUIRE OWNERSHIP CHECKS OR ADMIN.

  ## Examples

      iex> update_reply(reply, %{field: new_value})
      {:ok, %Reply{}}

      iex> update_reply(reply, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reply(%Reply{} = reply, attrs) do
    reply
    |> Reply.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Reply. DELETING REPLIES WILL REQUIRE OWNERSHIP CHECKS OR ADMIN.

  ## Examples

      iex> delete_reply(reply)
      {:ok, %Reply{}}

      iex> delete_reply(reply)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reply(%Reply{} = reply) do
    Repo.delete(reply)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reply changes.

  ## Examples

      iex> change_reply(reply)
      %Ecto.Changeset{source: %Reply{}}

  """
  def change_reply(%Reply{} = reply) do
    Reply.changeset(reply, %{})
  end
end
