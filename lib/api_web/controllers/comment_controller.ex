defmodule ApiWeb.CommentController do
  use ApiWeb, :controller

  use Api.Blog
  alias Api.Blog.Comment

  def index(conn, _params) do
    comment = list_comment()
    json(conn, %{comment: comment})
  end

  def create(conn, %{"comment" => comment_params}) do
    with {:ok, %Comment{} = comment} <- create_comment(comment_params) do
      conn
      |> put_status(:ok)
      |> put_resp_header("content-type", "application/json")
      |> json(%{comment: comment})
    else
      {:error, %Ecto.Changeset{} = %{errors: errors}} ->
        resp = get_errors(%{}, errors)

        conn
        |> put_status(:unprocessable_entity)
        |> put_resp_header("content-type", "application/json")
        |> json(%{errors: resp})

      _ ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{msg: "Server Error"})
    end
  end

  def show(conn, %{"id" => id}) do
    with %Comment{} = comment <- get_comment!(id) do
      conn
      |> put_status(:ok)
      |> put_resp_header("content-type", "application/json")
      |> json(%{comment: comment})
    else
      _ ->
        conn
        |> put_status(:not_found)
        |> json(%{msg: "Not found."})
    end
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = get_comment!(id)

    with {:ok, %Comment{} = comment} <- update_comment(comment, comment_params) do
      json(conn, %{comment: comment})
    else
      {:error, %Ecto.Changeset{} = %{errors: errors}} ->
        resp = get_errors(%{}, errors)

        conn
        |> put_status(:unprocessable_entity)
        |> put_resp_header("content-type", "application/json")
        |> json(%{errors: resp})

      _ ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{msg: "Server Error"})
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = get_comment!(id)

    with {:ok, %Comment{}} <- delete_comment(comment) do
      send_resp(conn, :no_content, "")
    end
  end
end
