defmodule ApiWeb.DraftControllerTest do
  use ApiWeb.ConnCase

  alias Api.Blog
  alias Api.Blog.Draft

  @create_attrs %{
    body: "some body",
    title: "some title"
  }
  @update_attrs %{
    body: "some updated body",
    title: "some updated title"
  }
  @invalid_attrs %{body: nil, title: nil}

  def fixture(:draft) do
    {:ok, draft} = Blog.create_draft(@create_attrs)
    draft
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all drafts", %{conn: conn} do
      conn = get(conn, Routes.draft_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create draft" do
    test "renders draft when data is valid", %{conn: conn} do
      conn = post(conn, Routes.draft_path(conn, :create), draft: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.draft_path(conn, :show, id))

      assert %{
               "id" => id,
               "body" => "some body",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.draft_path(conn, :create), draft: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update draft" do
    setup [:create_draft]

    test "renders draft when data is valid", %{conn: conn, draft: %Draft{id: id} = draft} do
      conn = put(conn, Routes.draft_path(conn, :update, draft), draft: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.draft_path(conn, :show, id))

      assert %{
               "id" => id,
               "body" => "some updated body",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, draft: draft} do
      conn = put(conn, Routes.draft_path(conn, :update, draft), draft: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete draft" do
    setup [:create_draft]

    test "deletes chosen draft", %{conn: conn, draft: draft} do
      conn = delete(conn, Routes.draft_path(conn, :delete, draft))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.draft_path(conn, :show, draft))
      end
    end
  end

  defp create_draft(_) do
    draft = fixture(:draft)
    {:ok, draft: draft}
  end
end
