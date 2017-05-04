defmodule EidelSolar.Piko.Fetch do

  def fetch(:root) do
    do_fetch(construct_url("/"), 60_000)
  end
  def fetch(:log_data) do
    do_fetch(construct_url("/LogDaten.dat"), 5_000)
  end

  defp construct_url(path) do
    ip = Application.get_env(:eidel_solar, EidelSolar.Piko)[:ip]
    user = Application.get_env(:eidel_solar, EidelSolar.Piko)[:user]
    password = Application.get_env(:eidel_solar, EidelSolar.Piko)[:password]

    "http://" <> user <> ":" <> password <> "@" <> ip <> path
    |> URI.encode
  end

  defp do_fetch(url, timeout) do
    case HTTPoison.get(url, [], recv_timeout: timeout) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, status_code}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
