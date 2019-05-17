defmodule ApiWeb.ReplyView do
  use ApiWeb, :view
  alias ApiWeb.ReplyView

  def render("index.json", %{replies: replies}) do
    %{data: render_many(replies, ReplyView, "reply.json")}
  end

  def render("show.json", %{reply: reply}) do
    %{data: render_one(reply, ReplyView, "reply.json")}
  end

  def render("reply.json", %{reply: reply}) do
    %{id: reply.id,
      comment: reply.comment,
      name: reply.name}
  end
end
