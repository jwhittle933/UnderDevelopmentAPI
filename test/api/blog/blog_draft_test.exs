defmodule Api.DraftTest do
  use Api.DataCase

  use Api.Blog
  use Api.Accounts
  alias Api.Blog.Draft
  alias Api.Accounts.User

  @valid_attrs %{body: "some body", title: "some title"}
  @update_attrs %{body: "some updated body", title: "some updated title"}
  @invalid_attrs %{body: nil, title: nil}


  describe "drafts" do
    def draft_fixture(attrs \\ %{}) do

      %User{id: id} = list_users() |> List.first

      {:ok, draft} =
        attrs
        |> Enum.into(%{user_id: id})
        |> Enum.into(@valid_attrs)
        |> create_draft()

      draft
    end

    test "list_drafts/0 returns all drafts" do
      draft = draft_fixture()
      assert list_drafts(draft.user_id) == [draft]
    end

    test "get_draft!/1 returns the draft with given id" do
      draft = draft_fixture()
      assert get_draft!(draft.id) == draft
    end

    test "create_draft/1 with valid data creates a draft" do
      draft = draft_fixture()
      assert draft.body == "some body"
      assert draft.title == "some title"
    end

    test "create_draft/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = create_draft(@invalid_attrs)
    end

    test "update_draft/2 with valid data updates the draft" do
      draft = draft_fixture()
      assert {:ok, %Draft{} = draft} = update_draft(draft, @update_attrs)
      assert draft.body == "some updated body"
      assert draft.title == "some updated title"
    end

    test "update_draft/2 with invalid data returns error changeset" do
      draft = draft_fixture()
      assert {:error, %Ecto.Changeset{}} = update_draft(draft, @invalid_attrs)
      assert draft == get_draft!(draft.id)
    end

    test "delete_draft/1 deletes the draft" do
      draft = draft_fixture()
      assert {:ok, %Draft{}} = delete_draft(draft)
      assert_raise Ecto.NoResultsError, fn -> get_draft!(draft.id) end
    end

    test "change_draft/1 returns a draft changeset" do
      draft = draft_fixture()
      assert %Ecto.Changeset{} = change_draft(draft)
    end
  end

end
