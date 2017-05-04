defmodule EidelSolar do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(EidelSolar.Repo, []),
      # Start the endpoint when the application starts
      supervisor(EidelSolar.Endpoint, []),
      # Phoenix Presence
      supervisor(EidelSolar.Presence, []),
      # Start your own worker by calling: EidelSolar.Worker.start_link(arg1, arg2, arg3)
      # worker(EidelSolar.Worker, [arg1, arg2, arg3]),
      worker(EidelSolar.Piko.CSVWorker, [])
      # worker(EidelSolar.Piko.MetersWorker, [])
      # worker(EidelSolar.Piko.FaultMonitorWorker, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EidelSolar.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    EidelSolar.Endpoint.config_change(changed, removed)
    :ok
  end
end
