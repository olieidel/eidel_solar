defmodule EidelSolar.EventControllerTest do
  use EidelSolar.ConnCase
  alias EidelSolar.Event

  @valid_attrs %{server_time: 1481928817,
                 time: %{day: 17, hour: 14, min: 0, month: 12, sec: 0, year: 2016},
                 name: "POR"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    conn = put_req_header(conn, "accept", "application/json")
    {:ok, conn: conn}
  end

  test "get events when empty", %{conn: conn} do
    conn = get conn, event_path(conn, :index)
    assert json_response(conn, 200) == %{"data" => []}
  end

  test "get events when one inserted", %{conn: conn} do
    changeset = Event.changeset(%Event{}, @valid_attrs)
    event = Repo.insert! changeset
    conn = get conn, event_path(conn, :index)
    assert json_response(conn, 200) == %{"data" => [%{"id" => event.id,
                                                     "name" => event.name,
                                                     "time" => Ecto.DateTime.to_iso8601(event.time)}]}
  end

  test "insert many events and return all", %{conn: conn} do
    for i <- 1..1000 do
      ts = 1481928817 + i
      {:ok, time} = DateTime.from_unix(ts)
      changeset = Event.changeset(%Event{}, %{server_time: ts,
                                              time: time,
                                              name: "POR"})
      event = Repo.insert! changeset
    end

    conn = get conn, event_path(conn, :index)
    assert Enum.count(json_response(conn, 200)["data"]) == 1000
  end
end
