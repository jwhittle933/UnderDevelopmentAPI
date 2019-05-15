defmodule ApiWeb.ReplyController do
  use ApiWeb, :controller

  alias Api.Blog
  alias Api.Blog.Reply

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    replies = Blog.list_replies()
    render(conn, "index.json", replies: replies)
  end

  def create(conn, %{"reply" => reply_params}) do
    with {:ok, %Reply{} = reply} <- Blog.create_reply(reply_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.reply_path(conn, :show, reply))
      |> render("show.json", reply: reply)
    end
  end

  def show(conn, %{"id" => id}) do
    reply = Blog.get_reply!(id)
    render(conn, "show.json", reply: reply)
  end

  def update(conn, %{"id" => id, "reply" => reply_params}) do
    reply = Blog.get_reply!(id)

    with {:ok, %Reply{} = reply} <- Blog.update_reply(reply, reply_params) do
      render(conn, "show.json", reply: reply)
    end
  end

  def delete(conn, %{"id" => id}) do
    reply = Blog.get_reply!(id)

    with {:ok, %Reply{}} <- Blog.delete_reply(reply) do
      send_resp(conn, :no_content, "")
    end
  end
end
