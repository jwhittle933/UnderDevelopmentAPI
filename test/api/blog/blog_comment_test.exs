defmodule Api.CommentTest do
  use Api.DataCase

  alias Api.Accounts
  alias Api.Blog
  alias Api.Blog.{Post, Comment}
  alias Api.Repo

  @fixture %Accounts.User{
    email: "some@email.com",
    name: "a user",
    password: "a password",
    admin: false,
    posts: [
      %Blog.Post {
        title: "a post",
        body: "a really long post",
        featured_image: "s3 somewhere",
        comments: [
          %Blog.Comment {
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

  defp fixture(context) do
    {:ok, user} = @fixture |> Repo.insert

    post = List.first(user.posts)
    comments = post.comments

    #cleanup
    on_exit fn ->
      IO.puts "Exiting Process: #{inspect self()}"
    end

    # merge metadata into context
    [user: user, post: post, comments: comments]
  end

  describe "comment" do

    setup :fixture

    test "list_comment/0 returns all comment", context do
      assert Blog.list_comment() == context[:comments]
    end

    test "get_comment!/1 returns the comment with given id", context do
      comment = List.first(context[:comments])
      assert comment == Blog.get_comment!(comment.id)
      assert comment.name == "a mean person"
      assert comment.comment == "this was not good."
    end

    # test "create_comment/1 with valid data creates a comment" do
    #   assert {:ok, %Comment{} = comment} = Blog.create_comment(@valid_attrs)
    #   assert comment.comment == "some comment"
    #   assert comment.name == "some name"
    # end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_comment(@invalid_attrs)
    end

    # test "update_comment/2 with valid data updates the comment" do
    #   comment = comment_fixture()
    #   assert {:ok, %Comment{} = comment} = Blog.update_comment(comment, @update_attrs)
    #   assert comment.comment == "some updated comment"
    #   assert comment.name == "some updated name"
    # end

    # test "update_comment/2 with invalid data returns error changeset" do
    #   comment = comment_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Blog.update_comment(comment, @invalid_attrs)
    #   assert comment == Blog.get_comment!(comment.id)
    # end

    # test "delete_comment/1 deletes the comment" do
    #   comment = comment_fixture()
    #   assert {:ok, %Comment{}} = Blog.delete_comment(comment)
    #   assert_raise Ecto.NoResultsError, fn -> Blog.get_comment!(comment.id) end
    # end

    # test "change_comment/1 returns a comment changeset" do
    #   comment = comment_fixture()
    #   assert %Ecto.Changeset{} = Blog.change_comment(comment)
    # end
  end

end
