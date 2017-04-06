defmodule Blog.Router do
  use Blog.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Blog.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authorize do
    plug Blog.Plugs.Authorize
  end

  scope "/", Blog do
    pipe_through :browser # Use the default browser stack

    resources "/", PostController, only: [:index, :show]

    # Sign in/out paths
    get "/authorize/new", UserSessionsController, :new, as: :sign_in
    delete "/authorize/delete", UserSessionsController, :delete, as: :sign_out
    get "/authorize/delete", UserSessionsController, :delete, as: :sign_out
  end

  # Api scope
  # scope "/api", Blog do
  #   pipe_through :api
  # end

  # Authenticated Scope.
  scope "/admin", Blog do
    pipe_through :browser
    pipe_through :authorize

    resources "/", PostController
  end
end
