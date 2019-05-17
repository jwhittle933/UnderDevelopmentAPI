defmodule Api.CommentTest do
  use Api.DataCase

  use Api.Blog
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

    # merge metadata into context
    [user: user, post: post, comments: comments]
  end

  describe "comment" do

    setup :fixture

    test "list_comment/0 returns all comment", context do
      assert list_comment() == context[:comments]
    end

    test "get_comment!/1 returns the comment with given id", context do
      comment = List.first(context[:comments])
      assert comment == get_comment!(comment.id)
      assert comment.name == "a mean person"
      assert comment.comment == "this was not good."
    end

    test "create_comment/1 with valid data creates a comment", context do
      new_comment = Enum.into(@valid_attrs, %{post_id: context[:post].id})
      assert {:ok, %Comment{} = comment} = create_comment(new_comment)
      assert comment.comment == "some comment"
      assert comment.name == "some name"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data upates the comment", context do
      comment = List.first(context[:comments])
      assert {:ok, %Comment{} = comment} = update_comment(comment, @update_attrs)
      assert comment.comment == "some updated comment"
      assert comment.name == "some updated name"
    end

    test "update_comment/2 with invalid data returns error changeset", context do
      comment = List.first(context[:comments])
      assert {:error, %Ecto.Changeset{}} = update_comment(comment, @invalid_attrs)
      assert comment == Blog.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment", context do
      comment = List.first(context[:comments])
      assert {:ok, %Comment{} = comment} = delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset", context do
      comment = List.first(context[:comments])
      assert %Ecto.Changeset{} = change_comment(comment)
    end
  end

end
