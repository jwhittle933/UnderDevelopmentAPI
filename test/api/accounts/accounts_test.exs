defmodule Api.AccountsTest do
  use Api.DataCase

  alias Api.Accounts

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
        |> Accounts.create_user()
        
      user
    end

    def invalid_user_fixture(attrs \\ %{}) do 
      {:ok, invalid_user} =
        attrs
        |> Enum.into(@invalid_attrs)
        |> Accounts.create_user()

      invalid_user
    end


    test "list_users/0 returns all users" do
      user = user_fixture()
      users = Accounts.list_users()
      assert Enum.count(users) > 0
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      %{name: name, email: email} = Accounts.get_user!(user.id)
      assert name == user.name
      assert email = user.email
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "someemail@email.com"
      assert user.name == "some name"
      assert user.password == "some password"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "anotheremail@email.com"
      assert user.name == "some updated name"
      assert user.password == "some updated password"
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end



  describe "subscription" do
    alias Api.Accounts.Subscription

    @valid_attrs %{
      email: "some email", 
      name: "some name"
    }
    @update_attrs %{
      email: "some updated email", 
      name: "some updated name"
    }
    @invalid_attrs %{email: nil, name: nil}

    def subscription_fixture(attrs \\ %{}) do
      {:ok, subscription} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_subscription()

      subscription
    end

    test "list_subscription/0 returns all subscription" do
      subscription = subscription_fixture()
      assert Accounts.list_subscription() == [subscription]
    end

    test "get_subscription!/1 returns the subscription with given id" do
      subscription = subscription_fixture()
      assert Accounts.get_subscription!(subscription.id) == subscription
    end

    test "create_subscription/1 with valid data creates a subscription" do
      assert {:ok, %Subscription{} = subscription} = Accounts.create_subscription(@valid_attrs)
      assert subscription.email == "some email"
      assert subscription.name == "some name"
    end

    test "create_subscription/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_subscription(@invalid_attrs)
    end

    test "update_subscription/2 with valid data updates the subscription" do
      subscription = subscription_fixture()
      assert {:ok, %Subscription{} = subscription} = Accounts.update_subscription(subscription, @update_attrs)
      assert subscription.email == "some updated email"
      assert subscription.name == "some updated name"
    end

    test "update_subscription/2 with invalid data returns error changeset" do
      subscription = subscription_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_subscription(subscription, @invalid_attrs)
      assert subscription == Accounts.get_subscription!(subscription.id)
    end

    test "delete_subscription/1 deletes the subscription" do
      subscription = subscription_fixture()
      assert {:ok, %Subscription{}} = Accounts.delete_subscription(subscription)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_subscription!(subscription.id) end
    end

    test "change_subscription/1 returns a subscription changeset" do
      subscription = subscription_fixture()
      assert %Ecto.Changeset{} = Accounts.change_subscription(subscription)
    end
  end


  defp get_resp_body(conn) do
    {:ok, conn} = Map.fetch(conn, :resp_body)
    conn |> Poison.decode
  end

end
