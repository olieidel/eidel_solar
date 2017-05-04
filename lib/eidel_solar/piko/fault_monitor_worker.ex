defmodule EidelSolar.Piko.FaultMonitorWorker do
  use GenServer
  use Timex

  require Ecto.Query
  alias Ecto.Query
  import Bamboo.Email

  alias EidelSolar.{Repo, Data, Mailer}

  @from_mail Application.get_env(:eidel_solar, EidelSolar.FaultMonitor)[:from]
  @to_mail Application.get_env(:eidel_solar, EidelSolar.FaultMonitor)[:to]

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    schedule_work(0)
    {:ok, nil}
  end

  def handle_info(:do_work, state) do
    last_power_hours_ago = last_data_with_power() |> hours_ago()
    IO.puts "FaultMonitorWorker: last data with power #{to_string last_power_hours_ago} hours ago"

    if last_power_hours_ago > 48 do
      IO.puts "FaultMonitorWorker: sending email to #{@to_mail}"
      send_email(to: @to_mail, hours_ago: last_power_hours_ago)
    end

    schedule_work(24)
    {:noreply, state}
  end

  def last_data_with_power() do
    Repo.one(Query.from d in Data,
      where: d.ac1_p > 0 and d.ac2_p > 0 and d.ac3_p > 0,
      select: d.time,
      order_by: [desc: d.time],
      limit: 1)
  end

  @spec hours_ago(Ecto.DateTime.type) :: non_neg_integer | {:error, term}
  def hours_ago(datetime) do
    now = Timex.now
    datetime =
      datetime
      |> Ecto.DateTime.to_erl

    Timex.diff(now, datetime, :hours)
  end

  def send_email(opts) do
    to = Keyword.fetch!(opts, :to)
    hours_ago = Keyword.fetch!(opts, :hours_ago)

    email =
      new_email
      |> to(to)
      |> from(@from_mail)
      |> subject("EidelSolar: Keine Leistung seit #{to_string hours_ago} Stunden")
      |> text_body("Der Wechselrichter hat seit #{to_string hours_ago} Stunden keine Leistung gebracht.")

    email |> Mailer.deliver_now
  end

  defp schedule_work(hours) do
    Process.send_after(self(), :do_work, hours * 24 * 60 * 60 * 1_000)
  end
end
