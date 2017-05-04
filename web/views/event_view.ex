defmodule EidelSolar.EventView do
  use EidelSolar.Web, :view

  def render("index.json", %{events: events}) do
    %{data: render_many(events, EidelSolar.EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    %{id: event.id,
      time: event.time,
      name: event.name}
  end
end
