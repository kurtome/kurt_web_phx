defmodule Kurt.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      KurtWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:kurt, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Kurt.PubSub},
      # Start a worker by calling: Kurt.Worker.start_link(arg)
      # {Kurt.Worker, arg},
      # Start to serve requests, typically the last entry
      KurtWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Kurt.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KurtWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
