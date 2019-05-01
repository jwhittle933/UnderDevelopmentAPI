defmodule ApiWeb.CommentControllerTest do
  use ApiWeb.ConnCase

  alias Api.Accounts
  alias Api.Blog
  alias ApiWeb.Blog.CommentController
  alias Poison

  @create_attrs %{
    comment: "some comment",
    name: "some name",
    post_id: 25
  }
  @update_attrs %{
    comment: "some updated comment",
    name: "some updated name",
    post_id: 25
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
      [head | _] = resp["comment"]
      assert %{"comment" => comment, "name" => name} = head
    end
  end

  describe "create comment" do
    test "renders comment when data is valid", %{conn: conn} do
      {:ok, resp} = 
      conn
      |> post(Routes.comment_path(conn, :create), comment: @create_attrs)
      |> get_resp_body

      IO.puts "Resp from :create"
      IO.inspect resp

      %{"id" => id, "comment" => comment, "name" => name, "post_id" => post_id} = resp["comment"]
      assert comment == @create_attrs[:comment]
      assert name == @create_attrs[:name]
      assert post_id == @create_attrs[:post_id]

      {:ok, resp} =
      conn
      |> get(Routes.comment_path(conn, :show, id))
      |> get_resp_body

      IO.puts "Resp from :show"
      IO.inspect resp

      assert %{
        "id" => _,
        "comment" => "some comment",
        "name" => "some name",
        "post_id" => _
      } = resp["comment"]
    end

    test "sends errors when data is invalid", %{conn: conn} do
      {:ok, resp} =
      conn
      |> post(Routes.comment_path(conn, :create), comment: @invalid_attrs)
      |> get_resp_body
  
      {:ok, errors} = resp["errors"] |> Poison.decode
      IO.puts "Errors:"
      IO.inspect errors

      assert %{
        "comment" => "can't be blank",
        "name" => "can't be blank",
        "post_id" => "can't be blank"
      } = errors

    end
  end

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
