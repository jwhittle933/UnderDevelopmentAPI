defmodule ApiWeb.CommentControllerTest do
  use ApiWeb.ConnCase

  alias Api.Accounts
  alias Api.Blog
  alias ApiWeb.Blog.CommentController
  alias Poison

  @create_attrs %{
    comment: "some comment",
    name: "some name"
  }
  @update_attrs %{
    comment: "some updated comment",
    name: "some updated name"
  }
  @invalid_attrs %{comment: nil, name: nil}

  def fixture(:comment) do
    {:ok, comment} = Accounts.create_comment(@create_attrs)
    comment
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all comment", %{conn: conn} do
      {:ok, resp} =
        conn
        |> get(Routes.comment_path(conn, :index))
        |> get_resp_body

    assert %{"comment" => comment} = resp
    end
  end

  # describe "create comment" do
  #   test "renders comment when data is valid", %{conn: conn} do
  #     conn = post(conn, Routes.comment_path(conn, :create), comment: @create_attrs)
  #     assert %{"id" => id} = json_response(conn, 201)["data"]

  #     conn = get(conn, Routes.comment_path(conn, :show, id))

  #     assert %{
  #              "id" => id,
  #              "comment" => "some comment",
  #              "name" => "some name"
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post(conn, Routes.comment_path(conn, :create), comment: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "update comment" do
  #   setup [:create_comment]

  #   test "renders comment when data is valid", %{conn: conn, comment: %Comment{id: id} = comment} do
  #     conn = put(conn, Routes.comment_path(conn, :update, comment), comment: @update_attrs)
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get(conn, Routes.comment_path(conn, :show, id))

  #     assert %{
  #              "id" => id,
  #              "comment" => "some updated comment",
  #              "name" => "some updated name"
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, comment: comment} do
  #     conn = put(conn, Routes.comment_path(conn, :update, comment), comment: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete comment" do
  #   setup [:create_comment]

  #   test "deletes chosen comment", %{conn: conn, comment: comment} do
  #     conn = delete(conn, Routes.comment_path(conn, :delete, comment))
  #     assert response(conn, 204)

  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.comment_path(conn, :show, comment))
  #     end
  #   end
  # end

  defp is_comments?(resp) do
    # 
  end

  defp create_comment(_) do
    comment = fixture(:comment)
    {:ok, comment: comment}
  end

  defp get_resp_body(conn) do
    {:ok, conn} = Map.fetch(conn, :resp_body)
    conn |> Poison.decode
  end

end
