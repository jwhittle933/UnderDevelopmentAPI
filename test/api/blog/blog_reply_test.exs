defmodule Api.BlogTest do
  use Api.DataCase

  use Api.Blog

  describe "replies" do
    alias Api.Blog.Reply

    @valid_attrs %{reply: "some comment", name: "some name"}
    @update_attrs %{reply: "some updated comment", name: "some updated name"}
    @invalid_attrs %{reply: nil, name: nil}

    def reply_fixture() do
      comment = list_comment() |> List.first

      {:ok, reply} =
        @valid_attrs
        |> Enum.into(%{comment_id: comment.id})
        |> create_reply()

      reply
    end

    test "list_replies/0 returns all replies" do
      reply = reply_fixture()
      assert list_replies() == [reply]
    end

    test "get_reply!/1 returns the reply with given id" do
      reply = reply_fixture()
      assert get_reply!(reply.id) == reply
    end

    test "create_reply/1 with valid data creates a reply" do
      reply = reply_fixture()
      assert reply.reply == "some comment"
      assert reply.name == "some name"
    end

    test "create_reply/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = create_reply(@invalid_attrs)
    end

    test "update_reply/2 with valid data updates the reply" do
      reply = reply_fixture()
      assert {:ok, %Reply{} = reply} = update_reply(reply, @update_attrs)
      assert reply.reply == "some updated comment"
      assert reply.name == "some updated name"
    end

    test "update_reply/2 with invalid data returns error changeset" do
      reply = reply_fixture()
      assert {:error, %Ecto.Changeset{}} = update_reply(reply, @invalid_attrs)
      assert reply == get_reply!(reply.id)
    end

    test "delete_reply/1 deletes the reply" do
      reply = reply_fixture()
      assert {:ok, %Reply{}} = delete_reply(reply)
      assert_raise Ecto.NoResultsError, fn -> get_reply!(reply.id) end
    end

    test "change_reply/1 returns a reply changeset" do
      reply = reply_fixture()
      assert %Ecto.Changeset{} = change_reply(reply)
    end
  end
end
