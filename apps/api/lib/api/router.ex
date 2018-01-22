defmodule API.Router do
  use API, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/v1", API do
    pipe_through :api

    resources "/reminders", ReminderController
  end
end
