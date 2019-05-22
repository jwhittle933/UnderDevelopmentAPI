defmodule ApiWeb.PostControllerTest do
  use ApiWeb.ConnCase

  use Api.Accounts
  use Api.Blog
  import Poison, only: [decode: 1]
  import Plug.Test
  alias Api.Blog.Post

  @create_attrs %{
    body: "some body",
    title: "some title",
    visible: true
  }
  @update_attrs %{
    body: "some updated body",
    title: "some updated title",
    visible: false
  }
  @invalid_attrs %{body: nil, title: nil, visible: nil}

  def fixture(:user) do
    list_users |> List.first()
  end

  def fixture(:post) do
    %{id: id} = fixture(:user)
    Enum.into(@create_attrs, %{user_id: id})
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      resp =
        conn
        |> get(Routes.post_path(conn, :index))
        |> get_resp_body

      refute is_nil(resp["posts"])

      Enum.each(resp["posts"], fn post ->
        refute is_nil(post["body"])
        refute is_nil(post["id"])
        refute is_nil(post["user"]["name"])
        refute is_nil(post["user"]["id"])
      end)
    end
  end

  describe "show" do
    test "show returns a single post", %{conn: conn} do
      valid_id = 190

      resp =
        conn
        |> get(Routes.post_path(conn, :show, valid_id))
        |> get_resp_body

      post = resp["post"]

      assert %{
               "id" => id,
               "body" => _,
               "comments" => comments,
               "title" => _,
               "featured_image" => _,
               "inserted_at" => _,
               "updated_at" => _,
               "user" => user,
               "visible" => _
             } = post

      assert %{
               "id" => _,
               "name" => _
             } = user

      Enum.each(comments, fn comment ->
        assert %{
                 "comment" => _,
                 "id" => _,
                 "name" => _,
                 "post_id" => post_id
               } = comment

        assert post_id == id
      end)
    end

    test "show raises Ecto.NoResultsError with bad post_id" do
      assert_raise(Ecto.NoResultsError, fn ->
        get(conn, Routes.post_path(conn, :show, 2000))
      end)
    end
  end

  describe "create post" do
    test "renders post when data is valid", %{conn: conn} do
      post = fixture(:post)

      resp =
        conn
        |> authenticate
        |> post(Routes.post_path(conn, :create, %{post: post}))
        |> get_resp_body

      assert %{
               "body" => "some body",
               "id" => id,
               "title" => "some title"
             } = resp

      resp =
        conn
        |> get(Routes.post_path(conn, :show, id))
        |> get_resp_body

      assert %{
               "body" => "some body",
               "comments" => [],
               "id" => ^id,
               "featured_image" => _,
               "title" => "some title",
               "user" => %{"id" => _, "name" => "Test User"},
               "visible" => _
             } = resp["post"]
    end

    test "Returns errors when data is invalid", %{conn: conn} do
      %{"errors" => errors} =
        conn
        |> authenticate
        |> post(Routes.post_path(conn, :create), post: @invalid_attrs)
        |> get_resp_body

      assert %{
               "body" => ["can't be blank"],
               "title" => ["can't be blank"],
               "user_id" => ["can't be blank"],
               "visible" => ["can't be blank"]
             } = errors
    end
  end

  describe "update post" do
    setup [:new_post]

    test "renders post when data is valid", %{conn: conn, post: %Post{id: id} = post} do
      %{"post" => post} =
        conn
        |> authenticate
        |> put(Routes.post_path(conn, :update, post), post: @update_attrs)
        |> get_resp_body

      assert %{"id" => id} = post

      resp =
        conn
        |> get(Routes.post_path(conn, :show, id))
        |> get_resp_body

      assert %{
               "id" => id,
               "body" => "some updated body",
               "title" => "some updated title"
             } = resp["post"]
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      %{"errors" => errors} =
        conn
        |> authenticate
        |> put(Routes.post_path(conn, :update, post), post: @invalid_attrs)
        |> get_resp_body

      assert %{
               "body" => ["can't be blank"],
               "title" => ["can't be blank"],
               "visible" => ["can't be blank"]
             } = errors
    end
  end

  describe "delete post" do
    setup [:new_post]

    test "deletes chosen post", %{conn: conn, post: post} do
      resp =
        conn
        |> authenticate
        |> delete(Routes.post_path(conn, :delete, post))

      assert resp.status == 204

      assert_error_sent 404, fn ->
        get(conn, Routes.post_path(conn, :show, post))
      end
    end
  end

  defp new_post(_) do
    {:ok, post} = fixture(:post) |> create_post
    [post: post]
  end

  defp get_resp_body(resp) do
    {:ok, body} = resp.resp_body |> decode
    body
  end

  defp authenticate(conn) do
    %{id: id} = fixture(:user)
    conn |> init_test_session(current_user_id: id)
  end
end
