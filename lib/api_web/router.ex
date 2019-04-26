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

  scope "/", ApiWeb do
    pipe_through :browser
  end

  scope "/api", ApiWeb do
    pipe_through :api

    post "/login", AuthController, :login
    post "/logout", AuthController, :logout

    resources "/users", UserController
    resources "/comments", CommentController
    resources "/posts", PostsController

  end
end
