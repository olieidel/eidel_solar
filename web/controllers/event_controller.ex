defmodule EidelSolar.EventController do
  use EidelSolar.Web, :controller
  # import Ecto.Query
  alias EidelSolar.Event

  def index(conn, _params) do
    events = Repo.all(from e in Event, order_by: [desc: :time])
    conn |> render("index.json", events: events)
  end
end
