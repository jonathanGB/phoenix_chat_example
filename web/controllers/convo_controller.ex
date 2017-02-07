defmodule Chat.ConvoController do
	use Chat.Web, :controller
	alias Chat.Repo
  alias Chat.User

	def index(conn, _params) do
		IO.inspect conn.cookies
		# query convos db
		render conn, "index.html" # , convos to pass
	end
end
