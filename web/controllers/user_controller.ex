defmodule Chat.UserController do
  use Chat.Web, :controller
	alias Chat.Repo
  alias Chat.User

  def index(conn, _params) do
    render conn, "index.html"
  end

	def create(conn, %{"tel" => telInput, "username" => usernameInput}) do
		User.changeset(%User{}, %{username: usernameInput, tel: telInput})
  	|> Repo.insert_or_update
		|> (fn (flag) ->
			Plug.Conn.put_resp_cookie(conn, "username", usernameInput)
			json conn, %{ok: flag}
  	end).()
	end
end
