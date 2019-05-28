defmodule ApiWeb.ReplyController do
  use ApiWeb, :controller

  use Api.Blog, :replies
  alias Api.Blog.Reply

  action_fallback ApiWeb.FallbackController

  def index(conn, %{"comment_id" => comment_id}) do
    replies = list_replies(comment_id)
    conn
    |> put_status(:ok)
    |> put_resp_header("content-type", "application/json")
    |> json(%{replies: replies})
  end

  def create(conn, %{"reply" => reply_params}) do
    with {:ok, %Reply{} = reply} <- create_reply(reply_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", 'application/json')
      |> json(%{reply: reply})
    end
  end

  def show(conn, %{"id" => id}) do
    reply = get_reply!(id)
    conn
    |> put_status(:ok)
    |> put_resp_header("content-type", "application/json")
    |> json(%{reply: reply})
  end

  def update(conn, %{"id" => id, "reply" => reply_params}) do
    reply = get_reply!(id)

    with {:ok, %Reply{} = reply} <- update_reply(reply, reply_params) do
      render(conn, "show.json", reply: reply)
    end
  end

  def delete(conn, %{"id" => id}) do
    reply = get_reply!(id)

    with {:ok, %Reply{}} <- delete_reply(reply) do
      send_resp(conn, :no_content, "")
    end
  end
end
