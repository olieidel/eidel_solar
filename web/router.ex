defmodule EidelSolar.Router do
  use EidelSolar.Web, :router

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

  scope "/api", EidelSolar do
    pipe_through :api

    get "/data", DataController, :index
    get "/events", EventController, :index
  end

  scope "/", EidelSolar do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", EidelSolar do
  #   pipe_through :api
  # end
end
