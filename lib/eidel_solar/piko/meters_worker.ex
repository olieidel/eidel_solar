defmodule EidelSolar.Piko.MetersWorker do
  use GenServer

  alias EidelSolar.Endpoint
  alias EidelSolar.Presence
  alias EidelSolar.Piko.{Fetch, Meters}

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_monitoring() do
    GenServer.cast(__MODULE__, :start_monitoring)
  end

  def stop_monitoring() do
    GenServer.cast(__MODULE__, :stop_monitoring)
  end

  def get_status() do
    GenServer.call(__MODULE__, :get_status)
  end

  def get_data() do
    GenServer.call(__MODULE__, :get_data)
  end

  def init([]) do
    state = %{started: false, data: nil}
    {:ok, state}
  end

  def handle_cast(:start_monitoring, %{started: started} = state) do
    case started do
      true -> {:noreply, state}
      false ->
        state = Map.put(state, :started, true)
        Process.send(self(), :fetch, [])
        {:noreply, state}
    end
  end

  def handle_cast(:stop_monitoring, state) do
    state = Map.put(state, :started, false)
    {:noreply, state}
  end

  def handle_info(:fetch, state) do
    IO.puts "MetersWorker: fetching data"

    case Fetch.fetch(:root) do
      {:ok, body} ->
        IO.puts "MetersWorker: data received"
        meters = Meters.parse(body)
        state = Map.put(state, :data, meters)

        Endpoint.broadcast!("meters:main", "new_data", meters)

        check_and_schedule(state)

        {:noreply, state}
      {:error, error} ->
        IO.puts "MetersWorker: error while fetching data"
        IO.inspect error
    end
  end

  def handle_call(:get_status, _from, state) do
    {:reply, {:ok, state[:started]}, state}
  end

  def handle_call(:get_data, _from, state) do
    {:reply, {:ok, state[:data]}, state}
  end

  defp schedule_work(seconds) when is_integer(seconds) do
    Process.send_after(self(), :fetch, seconds * 1000)
  end

  defp check_and_schedule(%{started: started} = state) do
    clients = Presence.list("meters:main") |> Enum.count()
    nobody_here = clients == 0
    stop = !started || nobody_here

    case stop do
      true ->
        IO.puts "MetersWorker: stopping"
        __MODULE__.stop_monitoring()
      false ->
        IO.puts "MetersWorker: next fetch in 3s"
        schedule_work(3)
    end
  end
end
