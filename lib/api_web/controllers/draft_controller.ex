defmodule ApiWeb.DraftController do
  use ApiWeb, :controller

  alias Api.Blog
  alias Api.Blog.Draft

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    user_id = get_session(:current_user_id)
    drafts = Blog.list_drafts(user_id)
    json conn, %{drafts: drafts}
  end

  def create(conn, %{"draft" => draft_params}) do
    with {:ok, %Draft{} = draft} <- Blog.create_draft(draft_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> json(%{draft: draft})
    end
  end

  def show(conn, %{"id" => id}) do
    draft = Blog.get_draft!(id)
    json conn, %{draft: draft}
  end

  def update(conn, %{"id" => id, "draft" => draft_params}) do
    draft = Blog.get_draft!(id)

    with {:ok, %Draft{} = draft} <- Blog.update_draft(draft, draft_params) do
      json conn, %{draft: draft}
    end
  end

  def delete(conn, %{"id" => id}) do
    draft = Blog.get_draft!(id)

    with {:ok, %Draft{}} <- Blog.delete_draft(draft) do
      send_resp(conn, :no_content, "")
    end
  end
end
