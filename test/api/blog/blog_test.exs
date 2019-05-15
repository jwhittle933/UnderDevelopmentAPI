defmodule Api.BlogTest do
  use Api.DataCase

  alias Api.Blog

  describe "replies" do
    alias Api.Blog.Reply

    @valid_attrs %{comment: "some comment", name: "some name"}
    @update_attrs %{comment: "some updated comment", name: "some updated name"}
    @invalid_attrs %{comment: nil, name: nil}

    def reply_fixture(attrs \\ %{}) do
      {:ok, reply} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Blog.create_reply()

      reply
    end

    test "list_replies/0 returns all replies" do
      reply = reply_fixture()
      assert Blog.list_replies() == [reply]
    end

    test "get_reply!/1 returns the reply with given id" do
      reply = reply_fixture()
      assert Blog.get_reply!(reply.id) == reply
    end

    test "create_reply/1 with valid data creates a reply" do
      assert {:ok, %Reply{} = reply} = Blog.create_reply(@valid_attrs)
      assert reply.comment == "some comment"
      assert reply.name == "some name"
    end

    test "create_reply/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_reply(@invalid_attrs)
    end

    test "update_reply/2 with valid data updates the reply" do
      reply = reply_fixture()
      assert {:ok, %Reply{} = reply} = Blog.update_reply(reply, @update_attrs)
      assert reply.comment == "some updated comment"
      assert reply.name == "some updated name"
    end

    test "update_reply/2 with invalid data returns error changeset" do
      reply = reply_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_reply(reply, @invalid_attrs)
      assert reply == Blog.get_reply!(reply.id)
    end

    test "delete_reply/1 deletes the reply" do
      reply = reply_fixture()
      assert {:ok, %Reply{}} = Blog.delete_reply(reply)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_reply!(reply.id) end
    end

    test "change_reply/1 returns a reply changeset" do
      reply = reply_fixture()
      assert %Ecto.Changeset{} = Blog.change_reply(reply)
    end
  end
end
