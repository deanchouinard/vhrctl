defmodule VhrCtlWeb.Router do
  use VhrCtlWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {VhrCtlWeb.LayoutView, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VhrCtlWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/hello:messenger", PageController, :hello
    post "/photo", UiController, :photo

    get "/ui", UiController, :index
    get "/list_pictures", UiController, :list_pictures
    get "/take_picture", UiController, :take_picture
    get "/ping", UiController, :ping
    get "/iflx", UiController, :iflx
    get "/mv_rbt", UiController, :mv_rbt
    get "/read_sensor", UiController, :read_sensor
    post "/mv_rbt", UiController, :move_rbt

  end

  # Other scopes may use custom stacks.
  scope "/api", VhrCtlWeb do
    pipe_through :api
    post "/env", ApiController, :env
   end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: VhrCtlWeb.Telemetry
    end
  end
end
