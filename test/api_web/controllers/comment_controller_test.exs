defmodule ApiWeb.CommentControllerTest do
  use ApiWeb.ConnCase

  alias Api.Accounts
  alias Api.Blog
  alias ApiWeb.Blog.CommentController
  alias Poison

  @create_attrs %{
    comment: "some comment",
    name: "some name",
    post_id: 25  # NO POSTS, SO post_id DOESN'T EXIST
  }
  @update_attrs %{
    comment: "some updated comment",
    name: "some updated name",
    post_id: 25
  }
  @invalid_attrs %{comment: nil, name: nil}

  def fixture(:comment) do
    {:ok, comment} = Blog.create_comment(@create_attrs)
    comment
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all comment", %{conn: conn} do
      {:ok, _} = fixture(:comment)
      {:ok, resp} =
        conn
        |> get(Routes.comment_path(conn, :index))
        |> get_resp_body

      assert %{"comment" => comment} = resp
      IO.inspect resp
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

      %{"id" => id, "comment" => comment, "name" => name, "post_id" => post_id} = resp["comment"]
      assert comment == @create_attrs[:comment]
      assert name == @create_attrs[:name]
      assert post_id == @create_attrs[:post_id]

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
      {:ok, %Blog.Comment{id: id} = comment} = @create_attrs |> Blog.create_comment
      conn = delete(conn, Routes.comment_path(conn, :delete, comment))
      assert response(conn, 204)

      {:ok, resp} =
      conn
      |> get(Routes.comment_path(conn, :show, id))
      |> Map.fetch(:status)

      assert resp == 404

    end
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
