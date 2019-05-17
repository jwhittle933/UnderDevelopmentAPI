defmodule Api.PostTest do
  use Api.DataCase

  use Api.Blog

  describe "posts" do
    alias Api.Blog.Post
    alias Api.Accounts.User

    @valid_attrs %{
      body: "some body", 
      title: "some title",
      featured_image: "image",
      visible: true,
    }
    @update_attrs %{
      body: "some updated body", 
      title: "some updated title",
      featured_image: "another image",
      visible: false
    }
    @invalid_attrs %{body: nil, title: nil, visible: nil}

    def post_fixture(attrs \\ %{}) do

      %Api.Accounts.User{id: id} =
        Api.Repo.all(User)
        |> List.first


      {:ok, post} =
        attrs
        |> Enum.into(%{user_id: id})
        |> Enum.into(@valid_attrs)
        |> create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      posts = list_posts()
      assert Enum.count(posts) != 0
      [%Post{body: body, title: title} | _] = posts
      assert body != nil
      assert title != nil
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      post = post_fixture()

      assert post.body == "some body"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = update_post(post, @update_attrs)
      assert post.body == "some updated body"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{} = changeset} = update_post(post, @invalid_attrs)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = change_post(post)
    end
  end
end
