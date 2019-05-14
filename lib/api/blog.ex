defmodule Api.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Api.Repo

  alias Api.Blog.Post
  alias Api.Accounts.User

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    # query = from u in Api.Accounts.User, select: [u.bio, u.name, u.id]
    Repo.all(Post)
    |> Repo.preload(:comments)
    |> Repo.preload([user: from(u in User, select: %{id: u.id, name: u.name})])
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id) do
    Repo.get!(Post, id)
    |> Repo.preload(:comments)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end

  alias Api.Blog.Comment

  @doc """
  Returns the list of comment.

  ## Examples

      iex> list_comment(
      [%Comment{}, ...]

  """
  def list_comment do
    Repo.all(Comment)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment,  id)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert
  end


  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{source: %Comment{}}

  """
  def change_comment(%Comment{} = comment) do
    Comment.changeset(comment, %{})
  end

  alias Api.Blog.Draft

  @doc """
  Returns the list of drafts.

  ## Examples

      iex> list_drafts(4)
      [%Draft{user_id: 4, ...}, ...]

  """
  def list_drafts(id) do
    Repo.all(Draft, [user_id: id])
  end

  @doc """
  Gets a single draft.

  Raises `Ecto.NoResultsError` if the Draft does not exist.

  ## Examples

      iex> get_draft!(123)
      %Draft{}

      iex> get_draft!(456)
      ** (Ecto.NoResultsError)

  """
  def get_draft!(id), do: Repo.get!(Draft, id)

  @doc """
  Creates a draft.

  ## Examples

      iex> create_draft(%{field: value})
      {:ok, %Draft{}}

      iex> create_draft(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_draft(attrs \\ %{}) do
    %Draft{}
    |> Draft.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a draft.

  ## Examples

      iex> update_draft(draft, %{field: new_value})
      {:ok, %Draft{}}

      iex> update_draft(draft, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_draft(%Draft{} = draft, attrs) do
    draft
    |> Draft.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Draft.

  ## Examples

      iex> delete_draft(draft)
      {:ok, %Draft{}}

      iex> delete_draft(draft)
      {:error, %Ecto.Changeset{}}

  """
  def delete_draft(%Draft{} = draft) do
    Repo.delete(draft)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking draft changes.

  ## Examples

      iex> change_draft(draft)
      %Ecto.Changeset{source: %Draft{}}

  """
  def change_draft(%Draft{} = draft) do
    Draft.changeset(draft, %{})
  end
end
