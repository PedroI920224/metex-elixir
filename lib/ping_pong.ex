defmodule PingPong do
  def execute do
    sender_pid = spawn(Ping, :loop, [])
    receptor_pid = spawn(Pong, :loop, [])
    send(receptor_pid, {:pong, sender_pid})
  end
end
defmodule Ping do
  def loop do
    receive do
      {:ping, sender_pid} ->
        :timer.sleep(3000)
        IO.puts "PONG"
        send(sender_pid, {:pong, self()})
      _ -> IO.puts "Invalid"
    end
    loop()
  end
end
defmodule Pong do
  def loop do
    receive do
      {:pong, sender_pid} ->
        :timer.sleep(3000)
        IO.puts "PING"
        send(sender_pid, {:ping, self()})
      _ -> IO.puts "Invalid"
    end
    loop()
  end
end
