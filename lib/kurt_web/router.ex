defmodule KurtWeb.Router do
  use KurtWeb, :router

  def set_env(conn, _opts) do
    env = Application.get_env(:kurt, :env)
    assign(conn, :env, env)
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :set_env
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {KurtWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  live_session :default do
    scope "/", KurtWeb do
      pipe_through :browser

      live "/", HomeLive.Index
      live "/:slug", HomeLive.Index
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", KurtWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:kurt, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: KurtWeb.Telemetry
    end
  end
end
