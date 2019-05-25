defmodule ApiWeb.DraftControllerTest do
  use ApiWeb.ConnCase

  use Api.Blog
  use Api.Accounts
  import ApiWeb.Helpers
  import Plug.Test
  alias Api.Blog.Draft
  alias Plug.Conn

  @create_attrs %{
    body: "some body",
    title: "some title"
  }
  @update_attrs %{
    body: "some updated body",
    title: "some updated title"
  }
  @invalid_attrs %{body: nil, title: nil}

  def fixture(:user) do
    user = list_users |> List.first()
  end

  def fixture(:draft) do
    %{id: id} = fixture(:user)
    @create_attrs |> Enum.into(%{user_id: id})
  end

  setup %{conn: conn} do
    conn = conn |> authenticate
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:new_draft]

    test "lists all drafts", %{conn: conn} do
      %{"drafts" => drafts} =
        conn
        |> get(Routes.user_draft_path(conn, :index, user_id(conn)))
        |> get_resp_body

      assert is_list(drafts)
      assert %{"body" => "some body", "title" => "some title", "user_id" => id} = drafts |> List.first
      refute is_nil(id)
    end
  end

  describe "create draft" do
    test "renders draft when data is valid", %{conn: conn} do
      draft = fixture(:draft)

      %{"draft" => draft} =
        conn
        |> post(Routes.user_draft_path(conn, :create, user_id(conn)), draft: draft)
        |> get_resp_body

      assert %{"id" => id} = draft

      %{"draft" => draft} =
        conn
        |> get(Routes.user_draft_path(conn, :show, user_id(conn), id))
        |> get_resp_body

      assert %{
               "id" => id,
               "body" => "some body",
               "title" => "some title"
             } = draft
    end

    test "renders errors when data is invalid", %{conn: conn} do
      %{"errors" => errors} =
        conn
        |> post(Routes.user_draft_path(conn, :create, user_id(conn)), draft: @invalid_attrs)
        |> get_resp_body

      assert errors != %{}
    end
  end

  describe "update draft" do
    setup [:new_draft]

    test "renders draft when data is valid", %{conn: conn, draft: %Draft{id: id} = draft} do
      %{"draft" => draft} =
        conn
        |> put(Routes.user_draft_path(conn, :update, user_id(conn), draft), draft: @update_attrs)
        |> get_resp_body

      assert %{"id" => ^id} = draft

      %{"draft" => draft} =
        conn
        |> get(Routes.user_draft_path(conn, :show, user_id(conn), id))
        |> get_resp_body

      assert %{
               "id" => id,
               "body" => "some updated body",
               "title" => "some updated title"
             } = draft
    end

    test "renders errors when data is invalid", %{conn: conn, draft: draft} do
      %{"errors" => errors} =
        conn
        |> put(Routes.user_draft_path(conn, :update, user_id(conn), draft), draft: @invalid_attrs)
        |> get_resp_body

      assert errors != %{}
    end
  end

  describe "delete draft" do
    setup [:new_draft]

    test "deletes chosen draft", %{conn: conn, draft: draft} do
      resp =
        conn
        |> delete(Routes.user_draft_path(conn, :delete, user_id(conn), draft))

      assert resp.status == 204
      assert resp.resp_body == ""

      assert_error_sent 404, fn ->
        conn |> get(Routes.user_draft_path(conn, :show, user_id(conn), draft))
      end
    end
  end

  defp new_draft(_) do
    {:ok, draft} = fixture(:draft) |> create_draft()
    [draft: draft]
  end

  defp user_id(conn) do
    conn.assigns.user.id
  end

  defp authenticate(conn) do
    %{id: id} = fixture(:user)
    conn |> init_test_session(current_user_id: id) |> Conn.assign(:user, %{id: id, name: "test user"})
  end
end
