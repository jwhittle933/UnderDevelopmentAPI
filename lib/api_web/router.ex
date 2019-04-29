defmodule ApiWeb.Router do
  use ApiWeb, :router

  alias ApiWeb.Plug.Authenticate

  @auth Authenticate

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug @auth
  end

  scope "/api", ApiWeb do
    pipe_through :api
    
    @doc """
      api requests to /api/comments or /api/posts @ :index, :show
      need no auth. This is for general readership

      !!For now, comments are exposed globally; see issues
    """
    resources "/posts", PostsController, only: [:index, :show]
    resources "/comments", CommentController

    @doc """
      Scope /api/auth for user login/logout

      !! Access to these endpoints will be controlled by UI
      !! where checks will be made on the session for 
      !! current_user and logged_in status. If nil, redirect
      !! user to login page. This will only apply to content
      !! creation and management
    """
    scope "/auth", ApiWeb do
      post "/login", AuthController, :login
      post "/logout", AuthController, :logout
    end

    @doc """
      Scope /api/users for authorized user content creation
      With this scheme, each post/draft will be associtated with 
      a user_id

      !! Still need to determine how to mangage and display
      !! user-associtated comments. Perhaps a new DB table?
    """
    scope "/users", ApiWeb do
      pipe_through :auth
      resources "/", UserController
      resources "/posts", PostsController, only: [:create, :update, :delete]
      resources "/drafts", DraftController
    end

  end
end
