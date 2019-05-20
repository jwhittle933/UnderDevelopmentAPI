defmodule Api.Blog.Fragments.Drafts do

  import Ecto.Changeset
  alias Api.Repo
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
