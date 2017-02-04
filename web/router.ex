defmodule Chat.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Chat do
    pipe_through :browser # Use the default browser stack

    get "/", UserController, :index # login page
		post "/user", UserController, :create # create user
		
		#get "/convos", ConvoController, :index # view to see all convos
		#get "/convos/:name", ConvoController, :show # view to see current convo
		#post "/convos", ConvoController, :create # view to create convo

		# post "/messages/", MessageController, :create # Twilio Endpoint when receiving SMS
  end
end
