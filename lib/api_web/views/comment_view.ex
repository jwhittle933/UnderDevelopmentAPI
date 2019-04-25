defmodule ApiWeb.CommentView do
  use ApiWeb, :view
  alias ApiWeb.CommentView

  def render("index.json", %{comment: comment}) do
    %{data: render_many(comment, CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{id: comment.id,
      name: comment.name,
      comment: comment.comment}
  end
end
