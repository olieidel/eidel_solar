defmodule EidelSolar.Piko.CSVWorker do
  use GenServer
  alias EidelSolar.Piko.{Fetch, CSV}

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    Process.send(self(), :fetch, [])
    {:ok, nil}
  end

  def handle_info(:fetch, state) do
    IO.puts "CSVWorker: Fetching data"
    now = DateTime.to_unix(DateTime.utc_now)

    case Fetch.fetch(:log_data) do
      {:ok, body} ->
        IO.puts "CSVWorker: Data received"
        body |> CSV.parse(now) |> CSV.insert
        schedule_work(30)
      {:error, error} ->
        IO.puts "CSVWorker: Error while fetching data"
        IO.inspect error
        schedule_work(60)
    end

    {:noreply, state}
  end

  def schedule_work(minutes) do
    Process.send_after(self(), :fetch, minutes * 60 * 1000)
  end
end
