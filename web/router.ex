defmodule JustCi.Router do
  use JustCi.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug JustCi.Plugs.LoggedInRedirect
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JustCi do
    pipe_through :browser # Use the default browser stack

    get "/", HomeController, :index
    resources "/templates", TemplateController do
      resources "/tasks", TaskController
    end

    resources "/builds", BuildController
    resources "/tasks", TaskController

    resources "/registrations", RegistrationController, only: [:new, :create]

    get "/login",  SessionController, :new
    post "/login",  SessionController, :create
    delete "/logout", SessionController, :delete

    get "/settings",  SettingsController, :index
    get "/settings/key", SettingsController, :new_key
    post "/settings/key", SettingsController, :create_key
  end

  # Other scopes may use custom stacks.
  scope "/api", JustCi do
    pipe_through :api

    put "/tasks/update_order", TaskController, :update_orders

    # GitHub Integration
    post "/github/event_handler", GithubController, :start_job
  end
end
