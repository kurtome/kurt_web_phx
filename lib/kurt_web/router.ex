defmodule KurtWeb.Router do
  use KurtWeb, :router

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

  scope "/", KurtWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/color-rand", PageController, :color_rand
    get "/:slug", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", KurtWeb do
  #   pipe_through :api
  # end
end
