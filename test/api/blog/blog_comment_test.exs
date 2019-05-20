defmodule Api.CommentTest do
  use Api.DataCase

  use Api.Blog
  alias Api.Accounts.User
  alias Api.Blog.{Post, Comment}
  alias Api.Repo

  @fixture %User{
    email: "some@email.com",
    name: "a user",
    password: "a password",
    admin: false,
    posts: [
      %Post {
        title: "a post",
        body: "a really long post",
        featured_image: "s3 somewhere",
        comments: [
          %Comment {
            name: "a mean person",
            comment: "this was not good."
          }
        ]
      }
    ]
  }

  @valid_attrs %{
    comment: "some comment",
    name: "some name",
  }
  @update_attrs %{
    comment: "some updated comment",
    name: "some updated name",
  }
  @invalid_attrs %{comment: nil, name: nil}

  defp fixture(_) do
    {:ok, user} = @fixture |> Repo.insert

    post = List.first(user.posts)
    comments = post.comments

    # merge metadata into context
    [user: user, post: post, comments: comments]
  end

  describe "comment" do

    setup :fixture

    test "list_comment/0 returns all comment" do
      comments = list_comment()
      refute is_nil(comments)
    end

    test "get_comment!/1 returns the comment with given id", %{comments: comments} do
      comment = List.first(comments)
      assert comment == get_comment!(comment.id)
      assert comment.name == "a mean person"
      assert comment.comment == "this was not good."
    end

    test "create_comment/1 with valid data creates a comment", %{post: post} do
      new_comment = Enum.into(@valid_attrs, %{post_id: post.id})
      assert {:ok, %Comment{} = comment} = create_comment(new_comment)
      assert comment.comment == "some comment"
      assert comment.name == "some name"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data upates the comment", %{comments: comments} do
      comment = List.first(comments)
      assert {:ok, %Comment{} = comment} = update_comment(comment, @update_attrs)
      assert comment.comment == "some updated comment"
      assert comment.name == "some updated name"
    end

    test "update_comment/2 with invalid data returns error changeset", %{comments: comments} do
      comment = List.first(comments)
      assert {:error, %Ecto.Changeset{}} = update_comment(comment, @invalid_attrs)
      assert comment == get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment", %{comments: comments} do
      comment = List.first(comments)
      assert {:ok, %Comment{} = comment} = delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset", %{comments: comments} do
      comment = List.first(comments)
      assert %Ecto.Changeset{} = change_comment(comment)
    end
  end

end
