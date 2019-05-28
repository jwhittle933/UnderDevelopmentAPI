defmodule ApiWeb.Router do
  use ApiWeb, :router

  @auth ApiWeb.Plug.Authenticate

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug @auth
  end

  scope "/api", ApiWeb do
    pipe_through :api

    @doc """
      api requests to /api/comments or /api/posts @ :index, :show
      need no auth. This is for general readership

    """
    resources "/posts", PostController, only: [:index, :show]
    resources "/comments", CommentController
    resources "/replies", ReplyController
    resources "/subscriptions", SubscriptionController
    get "/author", UserController, :author
    get "/authors", UserController, :authors

    @doc """
      Access to these endpoints will be controlled by UI
      where checks will be made on the session for
      current_user and logged_in status. If nil, redirect
      user to login page. This will only apply to content
      creation and management

      Once authenticated, a user map will be stored on the connection
      and a user_id will be stored in a session. These will be used
      in the UI for special access and controls.
    """
    post "/login", AuthController, :login
    get "/logout", AuthController, :logout

    @doc """
      Scope /api/users for authorized user content creation
      With this scheme, each post/draft will be associtated with
      a user_id
    """
    scope "/users" do
      pipe_through :auth
      resources "/", UserController do
        resources "/posts", PostController, only: [:create, :update, :delete]
        resources "/drafts", DraftController
      end
    end
  end
end
