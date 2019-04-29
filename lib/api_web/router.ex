defmodule ApiWeb.Router do
  use ApiWeb, :router

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

  # Although technically scopes can also be nested (just like resources), 
  # the use of nested scopes is generally discouraged because 
  # it can sometimes make our code confusing and less clear.

  scope "/api", ApiWeb do
    pipe_through :api
    
    @doc """
      api requests to /api/comments or /api/posts @ :index, :show
      need no auth. This is for general readership
    """
    resources "/comments", CommentController
    resources "/posts", PostsController, only: [:index, :show]

    @doc """
      Scope /api/auth for user login/logout
    """
    scope "/auth", ApiWeb do
      post "/login", AuthController, :login
      post "/logout", AuthController, :logout
    end

    @doc """
      Scope /api/users for authorized user content creation
    """
    scope "/users", ApiWeb do
      # plug :auth
      resources "/", UserController
      resources "/posts", PostsController, only: [:create, :update, :delete]
      resources "/drafts", DraftController
    end


  end
end
