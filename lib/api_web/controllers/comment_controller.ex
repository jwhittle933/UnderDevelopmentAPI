defmodule ApiWeb.CommentController do
  use ApiWeb, :controller

  alias Api.Blog
  alias Api.Blog.Comment


  def index(conn, _params) do
    comment = Blog.list_comment()
    json conn, %{comment: comment}
  end

  def create(conn, %{"comment" => comment_params}) do
    with {:ok, %Comment{} = comment} <- Blog.create_comment(comment_params) do
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
    comment = Blog.get_comment!(id)
    conn
    |> put_status(:ok)
    |> put_resp_header("content-type", "application/json")
    |> json(%{comment: comment})
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Blog.get_comment!(id)

    with {:ok, %Comment{} = comment} <- Blog.update_comment(comment, comment_params) do
      json conn, %{comment: comment}
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
        |> json %{msg: "Server Error"}
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Blog.get_comment!(id)

    with {:ok, %Comment{}} <- Blog.delete_comment(comment) do
      send_resp(conn, :no_content, "")
    end
  end

end
