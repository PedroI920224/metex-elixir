defmodule Metex.Coordinator do
  @doc """
  Execute_report is slowly because only spawn 2 processes, 1 for make all request in Metex.Worker.Processes.start_link
  the second one is a process to coordinate all responses and show then on screen

  ## Examples

      iex> cities = ["Singapore", "Monaco", "Vatican City", "Hong Kong", "Macau"]
      iex> Metex.Coordinator.execute_report(cities)
  """

  def execute_report(cities) do
    IO.puts("Hola 1")
    coordinator_pid = spawn( Metex.Coordinator, :loop, [[], Enum.count(cities)])
    IO.puts("Hola 2")
    { :ok, worker_pid } = Metex.Worker.Processes.start_link
    cities |> Enum.map(fn city -> send(worker_pid, {coordinator_pid, city }) end)
  end

  def execute_report_parallel(cities) do
    coordinator_pid = spawn( Metex.Coordinator, :loop, [[], Enum.count(cities)])
    cities |> Enum.map( fn city -> spawn(Metex.Worker.Processes, :loop, []) |> send({coordinator_pid, city}) end )
  end

  def loop(results \\ [], results_expected) do
    receive do
      {:ok, result} ->
        new_results = [result|results]
        if results_expected == Enum.count(new_results) do
          send self(), :exit
        end
        loop(new_results, results_expected)
      :exit ->
        IO.puts(results |> Enum.join(", "))
      _ ->
         loop(results, results_expected)
    end
  end
end
