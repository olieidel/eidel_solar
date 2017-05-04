defmodule EidelSolar.MetersChannelTest do
  use EidelSolar.ChannelCase, async: true

  alias EidelSolar.UserSocket
  alias EidelSolar.Piko.MetersWorker

  test "connect and join meters channel" do
    assert {:ok, socket} = connect(UserSocket, %{})
    assert {:ok, _reply, _socket} = subscribe_and_join(socket, "meters", %{})
  end

  test "new data pushed" do
    assert {:ok, socket} = connect(UserSocket, %{})
    assert {:ok, _reply, _socket} = subscribe_and_join(socket, "meters", %{})

    :timer.sleep(5_000)
    assert_push("new_data", payload)
    IO.inspect payload
  end

  test "presence" do
    {:ok, socket_1} = connect(UserSocket, %{})
    {:ok, _reply, socket_1} = subscribe_and_join(socket_1, "meters", %{})

    assert_push("presence_state", _payload)
    assert_push("presence_diff", _payload)

    {:ok, socket_2} = connect(UserSocket, %{})
    {:ok, _reply, socket_2} = subscribe_and_join(socket_2, "meters", %{})

    assert_push("presence_state", _payload)
    assert_push("presence_diff", _payload)
    assert_push("presence_diff", _payload)

    assert {:ok, true} = MetersWorker.get_status()

    Process.unlink(socket_1.channel_pid)
    leave(socket_1)
    :timer.sleep(6_000)
    assert {:ok, true} = MetersWorker.get_status()

    Process.unlink(socket_2.channel_pid)
    leave(socket_2)
    :timer.sleep(6_000)
    assert {:ok, false} = MetersWorker.get_status()
  end
end
