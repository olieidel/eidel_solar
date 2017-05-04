defmodule EidelSolar.Piko.CSV do
  use Timex

  alias EidelSolar.{Repo, Data, Event}
  alias EidelSolar.Piko.Fetch

  def parse(file, fetch_timestamp) do
    rows = String.split(file, "\n")

    # we need rows (starting at 0) 3, 7-end
    time_row = Enum.at(rows, 3)
    data_rows = Enum.slice(rows, 7..-1)

    {:time, server_fetched} = parse_row(time_row)

    data_rows
    |> Enum.map(&parse_row/1)
    |> Enum.filter(&(&1))
    |> Enum.filter(fn {type, _row} -> type in [:data, :event] end)
    |> Enum.map(&name_row/1)
    |> Enum.map(&(recalculate_timestamp(&1, server_fetched, fetch_timestamp)))
  end

  def parse_row({:not_needed, row}) do
    nil
  end
  def parse_row({:time, row}) do
    time = row |> Enum.at(1) |> String.to_integer
    {:time, time}
  end
  def parse_row({:data, row}) do
    # float index: 28
    # rest should be integers
    ac_f = row |> Enum.at(28) |> String.to_float
    new_row = row |> List.delete_at(28) |> Enum.map(&String.to_integer/1)
    new_row = new_row |> List.insert_at(28, ac_f)
    {:data, new_row}
  end
  def parse_row({:in_between, row}) do
    last_3 = Enum.slice(row, 38..40)
    time = List.first(row) |> String.to_integer
    weird_code = Enum.at(last_3, 0)
    mostly_zero = Enum.at(last_3, 1) |> String.to_integer
    max_int = Enum.at(last_3, 2) |> String.to_integer
    last_3 = [time, weird_code, mostly_zero, max_int]
    {:in_between, last_3}
  end
  def parse_row({:event, row}) do
    time = List.first(row) |> String.to_integer
    event = List.last(row)
    {:event, [time, event]}
  end
  def parse_row({:surprise, row}) do
    IO.puts("got surprise row, length: " <> to_string(Enum.count(row)))
    IO.inspect row
    {:surprise, row}
  end
  def parse_row(row) do
    row =
      row
      |> String.split("\t")
      |> Enum.map(&String.trim/1)

    row_type =
      case Enum.count(row) do # how many elements in row?
        1 -> :not_needed
        2 -> # might be time
          case List.first(row) do
            "akt. Zeit:" -> :time
            _ -> :not_needed
          end
        38 -> # good data point
          :data
        41 -> # turning off?
          :in_between
        42 -> # probably some event or turned off
          :event
        _ -> # surprise!
          :surprise
      end

    parse_row({row_type, row})
  end

  def name_row({:data, row}) do
    names = [:server_time, :dc1_u, :dc1_i, :dc1_p, :dc1_t, :dc1_s, :dc2_u,
             :dc2_i, :dc2_p, :dc2_t, :dc2_s, :dc3_u, :dc3_i, :dc3_p, :dc3_t,
             :dc3_s, :ac1_u, :ac1_i, :ac1_p, :ac1_t, :ac2_u, :ac2_i, :ac2_p,
             :ac2_t, :ac3_u, :ac3_i, :ac3_p, :ac3_t, :ac_f,  :fc_i, :ain1,
             :ain2, :ain3, :ain4, :ac_s, :err, :ens_s, :ens_err]
    map =
      Enum.zip(names, row)
      |> Enum.into(%{})
    {:data, map}
  end
  def name_row({:event, row}) do
    names = [:server_time, :name]
    map =
      Enum.zip(names, row)
      |> Enum.into(%{})
    {:event, map}
  end

  def recalculate_timestamp({row_type, %{server_time: item_created} = map},
    server_fetched, client_fetched) do
    timestamp = compute_timestamp(client_fetched, server_fetched, item_created)

    {:ok, time} = DateTime.from_unix(timestamp)

    map = Map.put(map, :time, time)
    {row_type, map}
  end

  @doc """
  All values are unix timestamps (seconds)
  """
  def compute_timestamp(client_fetched, server_fetched, item_created) do
    seconds_before_server_fetch = server_fetched - item_created
    client_fetched - seconds_before_server_fetch
  end

  def insert(maps) do
    maps
    |> Enum.map(&insert_row/1)
  end

  def insert_row({:data, map}) do
    changeset = Data.changeset(%Data{}, map)
    case Repo.insert(changeset) do
      {:ok, _data} -> :ok
      {:error, error} -> error
    end
  end
  def insert_row({:event, map}) do
    changeset = Event.changeset(%Event{}, map)
    case Repo.insert(changeset) do
      {:ok, _event} -> :ok
      {:error, error} -> error
    end
  end
end
