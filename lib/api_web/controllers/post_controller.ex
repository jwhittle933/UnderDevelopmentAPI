defmodule ApiWeb.PostController do
  use ApiWeb, :controller

  alias Api.Blog
  alias Api.Blog.Post

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    posts = Blog.list_posts()
    json conn, %{posts: posts}
  end

  @doc """
    :create method is hidden behind auth
  """
  def create(conn, %{"post" => post_params}) do
    with {:ok, %Post{} = post} <- Blog.create_post(post_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> json(%{id: post.id, body: post.body, title: post.title})
    end
  end

  def show(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    json conn, %{post: post}
  end

  @doc """
    :update method is hidden behind auth
  """
  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Blog.get_post!(id)

    with {:ok, %Post{} = post} <- Blog.update_post(post, post_params) do
      json conn, %{post: post}
    end
  end

  @doc """
    :delete method is hidden behind auth
  """
  def delete(conn, %{"id" => id}) do
    post = Blog.get_post!(id)

    with {:ok, %Post{}} <- Blog.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end

 end
