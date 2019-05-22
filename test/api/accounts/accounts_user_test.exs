defmodule Api.AccountsTest do
  use Api.DataCase

  use Api.Accounts

  describe "users" do
    alias Api.Accounts.User

    @valid_attrs %{
      email: "someemail@email.com",
      name: "some name",
      password: "some password",
      admin: true
    }
    @update_attrs %{
      email: "anotheremail@email.com",
      name: "some updated name",
      password: "some updated password",
      admin: false
    }
    @invalid_attrs %{email: nil, name: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> create_user()

      user
    end

    def invalid_user_fixture(attrs \\ %{}) do
      {:ok, invalid_user} =
        attrs
        |> Enum.into(@invalid_attrs)
        |> create_user()

      invalid_user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      users = list_users()
      assert Enum.count(users) > 0
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      %{name: name, email: email} = get_user(user.id)
      assert name == user.name
      assert email = user.email
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = create_user(@valid_attrs)
      assert user.email == "someemail@email.com"
      assert user.name == "some name"
      assert user.password == "some password"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = update_user(user, @update_attrs)
      assert user.email == "anotheremail@email.com"
      assert user.name == "some updated name"
      assert user.password == "some updated password"
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = delete_user(user)
      assert get_user(user.id) == nil
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = change_user(user)
    end
  end

  defp get_resp_body(conn) do
    {:ok, conn} = Map.fetch(conn, :resp_body)
    conn |> Poison.decode()
  end
end
