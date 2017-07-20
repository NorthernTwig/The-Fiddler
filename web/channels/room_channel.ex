defmodule TakeItForASpin.RoomChannel do
  use Phoenix.Channel

  @spin "spin"
  @initialize "initialize"  
  @move "move"  

  def join("room:fidget", _message, socket) do
    { :ok, socket }
  end

  def join("room:*", _message, _socket) do
    { :error, %{ reason: "There's only one fidget room!" } }
  end

  def handle_in(@spin, _body, socket) do
    new_speed = TakeItForASpin.State.increase_speed
    broadcast! socket, @spin, %{ speed: new_speed }
    { :noreply, socket }
  end

  def handle_in(@initialize, _body, socket) do
    current_speed = TakeItForASpin.State.get_speed
    position = %{ x: x, y: y } = TakeItForASpin.State.get_position
    broadcast! socket, @initialize, %{ speed: current_speed, position: position }
    { :noreply, socket }
  end

  def handle_in(@move, body, socket) do
    %{ x: x, y: y } = TakeItForASpin.State.set_position body
    broadcast! socket, @move, %{ position: %{ x: x, y: y } }
    { :noreply, socket }
  end
end