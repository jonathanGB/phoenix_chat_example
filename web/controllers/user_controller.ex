defmodule Chat.UserController do
  use Chat.Web, :controller
	alias Chat.Repo
  alias Chat.User

  def index(conn, _params) do
    render conn, "index.html"
  end

	def create(conn, %{"tel" => telInput, "username" => usernameInput}) do
		result =
		  case Repo.get_by(User, username: usernameInput) do
		    nil  -> %User{username: usernameInput, tel: telInput}
		    user -> user
		  end
		  |> User.changeset(%{username: usernameInput, tel: telInput})
		  |> Repo.insert_or_update


		case result do
		  {:ok, _}       ->
				cookieConn = Plug.Conn.put_resp_cookie(conn, "username", usernameInput)
				json cookieConn, %{ok: true}
		  {:error, _} ->
				json conn, %{ok: false}
		end
	end
end
