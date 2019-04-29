defmodule ApiWeb.DraftView do
  use ApiWeb, :view
  alias ApiWeb.DraftView

  def render("index.json", %{drafts: drafts}) do
    %{data: render_many(drafts, DraftView, "draft.json")}
  end

  def render("show.json", %{draft: draft}) do
    %{data: render_one(draft, DraftView, "draft.json")}
  end

  def render("draft.json", %{draft: draft}) do
    %{id: draft.id,
      body: draft.body,
      title: draft.title}
  end
end
