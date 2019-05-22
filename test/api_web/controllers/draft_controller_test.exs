defmodule ApiWeb.DraftControllerTest do
  use ApiWeb.ConnCase

  use Api.Blog
  use Api.Accounts
  alias Api.Blog.Draft
  import Plug.Test
  import ApiWeb.Helpers

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
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all drafts", %{conn: conn} do
      resp =
        conn
        |> authenticate
        |> get(Routes.draft_path(conn, :index))
        |> get_resp_body

      IO.inspect(resp)

      # assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create draft" do
    test "renders draft when data is valid", %{conn: conn} do
      draft = fixture(:draft)

      %{"draft" => draft} =
        conn
        |> authenticate
        |> post(Routes.draft_path(conn, :create), draft: draft)
        |> get_resp_body

      assert %{"id" => id} = draft

      %{"draft" => draft} =
        conn
        |> authenticate
        |> get(Routes.draft_path(conn, :show, id))
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
        |> authenticate
        |> post(Routes.draft_path(conn, :create), draft: @invalid_attrs)
        |> get_resp_body

      assert errors != %{}
    end
  end

  describe "update draft" do
    setup [:new_draft]

    test "renders draft when data is valid", %{conn: conn, draft: %Draft{id: id} = draft} do
      %{"draft" => draft} =
        conn
        |> authenticate
        |> put(Routes.draft_path(conn, :update, draft), draft: @update_attrs)
        |> get_resp_body

      assert %{"id" => ^id} = draft

      %{"draft" => draft} =
        conn
        |> authenticate
        |> get(Routes.draft_path(conn, :show, id))
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
        |> authenticate
        |> put(Routes.draft_path(conn, :update, draft), draft: @invalid_attrs)
        |> get_resp_body

      assert errors != %{}
    end
  end

  describe "delete draft" do
    setup [:new_draft]

    test "deletes chosen draft", %{conn: conn, draft: draft} do
      resp =
        conn
        |> authenticate
        |> delete(Routes.draft_path(conn, :delete, draft))

      assert resp.status == 204
      assert resp.resp_body == ""

      assert_error_sent 404, fn ->
        conn |> authenticate |> get(Routes.draft_path(conn, :show, draft))
      end
    end
  end

  defp new_draft(_) do
    {:ok, draft} = fixture(:draft) |> create_draft()
    [draft: draft]
  end

  defp authenticate(conn) do
    %{id: id} = fixture(:user)
    conn |> init_test_session(current_user_id: id)
  end
end
