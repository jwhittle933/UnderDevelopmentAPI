defmodule ApiWeb.CommentControllerTest do
  use ApiWeb.ConnCase

  alias Api.Blog
  alias Poison

  @create_attrs %{
    comment: "some comment",
    name: "some name",
  }
  @update_attrs %{
    comment: "some updated comment",
    name: "some updated name",
  }
  @invalid_attrs %{comment: nil, name: nil}

  def fixture(:comment) do
    post = Api.Repo.all(Blog.Post) |> List.first

    Map.put(@create_attrs, :post_id, post.id)
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
      [head | _] = comment
      assert %{"id" => _, "comment" => _, "name" => _} = head
    end
  end

  describe "create comment" do
    test "renders comment when data is valid", %{conn: conn} do

      {:ok, comment} = create_comment()

      {:ok, resp} =
      conn
      |> post(Routes.comment_path(conn, :create), comment: comment)
      |> get_resp_body

      %{
        "id" => id,
        "comment" => comment,
        "name" => name,
      } = resp["comment"]

      assert comment == @create_attrs[:comment]
      assert name == @create_attrs[:name]

      {:ok, resp} =
      conn
      |> get(Routes.comment_path(conn, :show, id))
      |> get_resp_body

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

      assert %{
        "comment" => "can't be blank",
        "name" => "can't be blank",
        "post_id" => "can't be blank"
      } = errors

    end
  end

  describe "update comment" do
    test "renders comment when data is valid", %{conn: conn} do
      with {:ok, %Blog.Comment{id: id} = comment} <- Blog.create_comment(@create_attrs) do
        {:ok, resp} =
        conn
        |> put(Routes.comment_path(conn, :update, comment), comment: @update_attrs)
        |> get_resp_body

        {:ok, resp} =
        conn
        |> get(Routes.comment_path(conn, :show, id))
        |> get_resp_body

        assert %{
          "id" => _,
          "comment" => "some updated comment",
          "name" => "some updated name"
          } = resp["comment"]
      end
    end

    test "sends errors when data is invalid", %{conn: conn} do
      with {:ok, %Blog.Comment{id: id} = comment} <- Blog.create_comment(@create_attrs) do
        {:ok, resp} =
        conn
        |> put(Routes.comment_path(conn, :update, comment), comment: @invalid_attrs)
        |> get_resp_body

        {:ok, errors} = resp["errors"] |> Poison.decode

        assert %{
          "comment" => "can't be blank",
          "name" => "can't be blank"
        } == errors
      end
    end
  end

  describe "delete comment" do
    test "deletes chosen comment", %{conn: conn} do
      {:ok, temp_comment} = create_comment()
      {:ok, %Blog.Comment{} = comment} = Blog.create_comment(temp_comment)

      conn = delete(conn, Routes.comment_path(conn, :delete, comment))
      assert response(conn, 204)
    end
  end


  defp create_comment() do
    comment = fixture(:comment)
    {:ok, comment}
  end

  defp get_resp_body(conn) do
    {:ok, conn} = Map.fetch(conn, :resp_body)
    conn |> Poison.decode
  end

end
