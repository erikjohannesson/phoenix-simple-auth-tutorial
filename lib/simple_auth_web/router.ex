defmodule SimpleAuthWeb.Router do
  use SimpleAuthWeb, :router

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

  pipeline :with_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug SimpleAuth.CurrentUser
  end

  pipeline :login_required do
  end

  pipeline :admin_required do
  end

  # guest zone
  scope "/", SimpleAuthWeb do
    pipe_through [:browser, :with_session] # Use the default browser stack

    get "/", PageController, :index

    resources "/users", UserController, only: [:new, :create]

    resources "/sessions", SessionController, only: [:new, :create, :delete], singleton: true
  end

  # registered user zone
  scope "/", SimpleAuthWeb do
    pipe_through [:browser, :with_session, :login_required]

    resources "/users", UserController, only: [:show] do
      resources "/posts", PostController
    end
  end

  # admin zone
  scope "/admin", SimpleAuthWeb.Admin, as: :admin do
    pipe_through [:browser, :with_session, :login_required, :admin_required]

    resources "/users", UserController, only: [:index, :show] do
      resources "/posts", PostController, only: [:index, :show]
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", SimpleAuthWeb do
  #   pipe_through :api
  # end
end
