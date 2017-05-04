defmodule EidelSolar.PikoTest do
  use EidelSolar.ConnCase

  alias EidelSolar.Piko

  # @tag timeout: 600_000
  # test "get and write to file" do
  #   IO.puts "fetching logdata"
  #   Piko.fetch |> Piko.write
  #   assert File.exists?("logdata.txt")
  # end

  test "read only data and events" do
    file = File.read!("test/lib/logdata/1.txt")
    now = DateTime.utc_now |> DateTime.to_unix
    parsed = file |> Piko.parse(now)
    assert Enum.count(parsed) == 9
  end

  test "insert data and events, ignoring duplicates" do
    file = File.read!("test/lib/logdata/1.txt")
    now = DateTime.utc_now |> DateTime.to_unix
    parsed = file |> Piko.parse(now)
    inserted = parsed |> Piko.insert
    assert Enum.count(inserted) == 9
    insertions = inserted |> Enum.filter(&(&1 == :ok)) |> Enum.count
    assert insertions  == 7
  end

  test "insert performance is okay" do
    file = File.read!("test/lib/logdata/1.txt")
    now = DateTime.utc_now |> DateTime.to_unix
    inserted = file |> Piko.parse(now) |> Piko.insert
    assert inserted
  end
end
