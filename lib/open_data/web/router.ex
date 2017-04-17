defmodule OpenData.Web.Router do
  use OpenData.Web, :router

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

  scope "/api", OpenData.Web do
    pipe_through :api
    resources "/datastores", DatastoreController, except: [:new, :edit]

  end

  scope "/", OpenData.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    # get "/*path", PageController, :index
  end
end
