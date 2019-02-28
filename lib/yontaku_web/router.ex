defmodule YontakuWeb.Router do
  use YontakuWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/webhook", YontakuWeb do
    pipe_through :api

    get "/", WebhookController, :index 
    post "/", WebhookController, :webhook
  end
end
