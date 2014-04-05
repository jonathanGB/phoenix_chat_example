# Chat

To start your new Phoenix application you have to:

1. Install dependencies with `mix deps.get`
2. Start Phoenix router with `mix run -e 'Chat.Config.Router.start' --no-halt mix.exs`

Now you can visit `localhost:4000` from your browser.


## Example

#### JavaScript
```javascript
$(function(){
  var socket     = new Phoenix.Socket("ws://" + location.host +  "/ws");
  var $status    = $("#status");
  var $messages  = $("#messages");
  var $input     = $("#message-input");
  var $username  = $("#username");
  var sanitize   = function(html){ return $("<div/>").text(html).html(); }

  var messageTemplate = function(message){
    var username = sanitize(message.username || "anonymous");
    var body     = sanitize(message.body);
    return("<p><a href='#'>[" + username + "]</a>&nbsp; " + body +"</p>");
  }

  socket.join("rooms", "lobby", {}, function(chan){

    $input.off("keypress").on("keypress", function(e) {
      if (e.keyCode == 13) {
        chan.send("new:message", {username: $username.val(), body: $input.val()});
        $input.val("");
      }
    });

    chan.on("join", function(message){
      $status.text("joined");
    });

    chan.on("new:message", function(message){
      $messages.append(messageTemplate(message));
      scrollTo(0, document.body.scrollHeight);
    });

    chan.on("user:entered", function(msg){
      $messages.append("<br/><i>[" + msg.username + " entered]</i>");
    });
  });
});
 ```

#### Router
```elixir
defmodule Chat.Router do
  use Phoenix.Router
  use Phoenix.Router.Socket, mount: "/ws"

  plug Plug.Static, at: "/static", from: :chat
  get "/", Chat.Controllers.Pages, :index, as: :page

  channel "rooms", Chat.Channels.Rooms
end
```

#### Channel
```elixir
defmodule Chat.Channels.Rooms do
  use Phoenix.Channel

  def join(socket, message) do
    IO.puts "JOIN #{socket.channel}:#{socket.topic}"
    reply socket, "join", status: "connected"
    broadcast socket, "user:entered", username: message["username"]
    {:ok, socket}
  end

  def event("new:message", socket, message) do
    broadcast socket, "new:message", message
    {:ok, socket}
  end
end
```
