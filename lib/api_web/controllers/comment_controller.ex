defmodule ApiWeb.CommentController do
  use ApiWeb, :controller

  alias Api.Blog
  alias Api.Blog.Comment

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    comment = Blog.list_comment()
    json conn, comment: comment
  end

  def create(conn, %{"comment" => comment_params}) do
    with {:ok, %Comment{} = comment} <- Blog.create_comment(comment_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, comment: comment)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Blog.get_comment!(id)
    json conn, comment: comment
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Blog.get_comment!(id)

    with {:ok, %Comment{} = comment} <- Blog.update_comment(comment, comment_params) do
      json conn, comment: comment
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Blog.get_comment!(id)

    with {:ok, %Comment{}} <- Blog.delete_comment(comment) do
      send_resp(conn, :no_content, "")
    end
  end
end
