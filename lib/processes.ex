defmodule Metex.Worker.Processes do

  @doc """
  This library only spawn a process, only one, this is slowly because we need shot process in parallel way
  how to run:
    Metex.Worker.Process.start_link

  ## Examples

      iex> MetexElixir.hello()
      :world

  """

  def start_link do
    Task.start_link(fn -> loop() end)
  end

  def loop do
    receive do
      {sender_pid, location} -> send(sender_pid, {:ok, Metex.Worker.temperature_of(location)})
      _ -> IO.puts  "don't know how to process this message"
    end
    loop()
  end
end
