defmodule EidelSolar.MetersChannel do
  use EidelSolar.Web, :channel

  alias EidelSolar.Presence
  alias EidelSolar.Piko.MetersWorker

  def join("meters:main", _params, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    n = Enum.count(Presence.list(socket))
    Presence.track(socket, "user_#{n}", %{})

    MetersWorker.start_monitoring()

    push(socket, "presence_state", Presence.list(socket))

    {:ok, data} = MetersWorker.get_data()
    if Enum.count(data) > 0 do
      push(socket, "new_data", data)
    end

    {:noreply, socket}
  end
end
