defmodule ApiWeb.UserController do
  use ApiWeb, :controller

  use Api.Accounts
  alias Api.Accounts.User

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    users = list_users()
    conn
    |> put_status(:ok)
    |> put_resp_header("content-type", "application/json")
    |> json(%{users: users})
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> json(%{user: user})
    end
  end

  def show(conn, %{"id" => id}) do
    user = get_user(id)
    conn
    |> put_status(:ok)
    |> put_resp_header("content-type", "application/json")
    |> json(%{user: user})
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = get_user(id)

    with {:ok, %User{} = user} <- update_user(user, user_params) do
      conn |> json(%{user: user})
    end
  end

  def delete(conn, %{"id" => id}) do
    user = get_user(id)

    with {:ok, %User{}} <- delete_user(user) do
      conn
      |> put_status(:no_content)
      |> json(%{msg: "User deleted."})
    end
  end

  def author(conn, %{"id" => id}) do
    author = get_author(id)
    conn
    |> put_status(:ok)
    |> put_resp_header("content-type", "application/json")
    |> json(%{author: author})
  end

  def authors(conn, _params) do
    authors = list_authors()
    conn
    |> put_status(:ok)
    |> put_resp_header("content-type", "application/json")
    |> json(%{authors: authors})
  end

  defp get_list_authors do
    %{name: name, id: id, bio: bio} = list_users()
  end
end
