defmodule ApiWeb.DraftController do
  use ApiWeb, :controller

  use Api.Blog, :drafts
  alias Api.Blog.Draft

  action_fallback ApiWeb.FallbackController

  def index(conn, %{"user_id" => user_id}) do
    with user_id <- get_session(conn, :current_user_id) do
      drafts = list_drafts(user_id)
      json(conn, %{drafts: drafts})
    else
      _ ->
        conn
        |> put_status(:unathorized)
        |> put_resp_header("content-type", "application/json")
        |> json(%{msg: "You are not authorized to view this draft."})
    end
  end

  def create(conn, %{"draft" => draft_params}) do
    with {:ok, %Draft{} = draft} <- create_draft(draft_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> json(%{draft: draft})
    end
  end

  def show(conn, %{"id" => id}) do
    draft = get_draft!(id)
    json(conn, %{draft: draft})
  end

  def update(conn, %{"id" => id, "draft" => draft_params}) do
    draft = get_draft!(id)

    with {:ok, %Draft{} = draft} <- update_draft(draft, draft_params) do
      json(conn, %{draft: draft})
    end
  end

  def delete(conn, %{"id" => id}) do
    draft = get_draft!(id)

    with {:ok, %Draft{}} <- delete_draft(draft) do
      send_resp(conn, :no_content, "")
    end
  end
end
