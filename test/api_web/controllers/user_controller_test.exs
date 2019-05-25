defmodule ApiWeb.UserControllerTest do
  use ApiWeb.ConnCase

  use Api.Accounts
  alias Api.Accounts.User
  alias Plug.Conn
  import ApiWeb.Helpers
  import Plug.Test

  @create_attrs %{
    email: "someemail@user.com",
    name: "some name",
    password: "some password",
    admin: true
  }
  @update_attrs %{
    email: "anotheremail@user.com",
    name: "some updated name",
    password: "some updated password",
    admin: false
  }
  @invalid_attrs %{email: nil, name: nil, password: nil, admin: nil}

  def fixture(:user) do
    {:ok, user} = create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    conn = conn |> authenticate
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      %{"users" => users} =
        conn
        |> get(Routes.user_path(conn, :index))
        |> get_resp_body

      assert is_list(users)
      Enum.each(users, fn user ->
        assert %{
          "id" => _,
          "name" => _,
          "admin" => _,
          "bio" => _,
          "password_hash" => _
        } = user
      end)
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      %{"user" => user} =
        conn
        |> post(Routes.user_path(conn, :create), user: @create_attrs)
        |> get_resp_body

      assert %{
        "id" => id,
        "admin" => _,
        "bio" => _,
        "email" => "someemail@user.com",
        "name" => "some name",
        "password_hash" => _
      } = user

      %{"user" => user} =
        conn
        |> get(Routes.user_path(conn, :show, id))
        |> get_resp_body


      assert %{
        "id" => id,
        "bio" => _,
        "admin" => _,
        "email" => "someemail@user.com",
        "name" => "some name",
        "password_hash" => _
      } = user
    end

    test "renders errors when data is invalid", %{conn: conn} do
      %{"errors" => errors} =
        conn
        |> post(Routes.user_path(conn, :create), user: @invalid_attrs)
        |> get_resp_body

      assert errors != %{}
    end
  end

  describe "update user" do
    setup [:new_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      %{"user" => user} =
        conn
        |> put(Routes.user_path(conn, :update, user), user: @update_attrs)
        |> get_resp_body

      assert user["id"] == id

      %{"user" => user} =
        conn
        |> get(Routes.user_path(conn, :show, id))
        |> get_resp_body

      assert %{
               "id" => id,
               "email" => "anotheremail@user.com",
               "name" => "some updated name",
               "password_hash" => _
             } = user
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      %{"errors" => errors} =
        conn
        |> put(Routes.user_path(conn, :update, user), user: @invalid_attrs)
        |> get_resp_body
      assert errors != %{}
    end
  end

  describe "delete user" do
    setup [:new_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      %{"msg" => msg} =
        conn
        |> delete(Routes.user_path(conn, :delete, user))
        |> get_resp_body

      assert msg == "User deleted."

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  describe "authors" do
    setup [:new_user]

    test "sends list of authors" do
      %{"authors" => authors} =
        conn
        |> get(Routes.user_path(conn, :authors))
        |> get_resp_body

      assert is_list(authors)
      Enum.each(authors, fn author ->
        assert %{"bio" => _, "id" => _, "name" => _} = author
      end)
    end

    test "sends a single author", %{user: user} do
      %{"author" => author} =
        conn
        |> get(Routes.user_path(conn, :author), id: user.id)
        |> get_resp_body

      assert %{"id" => _, "bio" => _, "name" => _} = author
    end
  end

  defp new_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end

  defp authenticate(conn) do
    %{id: id} = fixture(:user)
    conn |> init_test_session(current_user_id: id) |> Conn.assign(:user, %{id: id})
  end

end
