defmodule EidelSolar.DataControllerTest do
  use EidelSolar.ConnCase
  alias EidelSolar.{Data, Piko}

  @valid_attrs %{server_time: 1481928817,
                 time: %{day: 17, hour: 14, min: 0, month: 12, sec: 0, year: 2016},
                 dc1_u: 123}
  @invalid_attrs %{}

  setup %{conn: conn} do
    conn = put_req_header(conn, "accept", "application/json")
    {:ok, conn: conn}
  end

  test "get data when empty", %{conn: conn} do
    conn = get conn, data_path(conn, :index)
    assert json_response(conn, 200) == %{"data" => []}
  end

  test "get data when one inserted", %{conn: conn} do
    now = DateTime.utc_now |> DateTime.to_unix
    data = File.read!("test/lib/logdata/1.txt") |> Piko.parse(now) |> Piko.insert
    conn = get conn, data_path(conn, :index)
    response = json_response(conn, 200)
    assert Enum.count(response["data"]) > 0
  end

  test "insert lots of data and return all", %{conn: conn} do
    now = DateTime.utc_now |> DateTime.to_unix
    data = File.read!("test/lib/logdata/complete.txt") |> Piko.parse(now) |> Piko.insert

    conn = get conn, data_path(conn, :index)
    response = json_response(conn, 200)
    assert Enum.count(response) > 0
  end
end
