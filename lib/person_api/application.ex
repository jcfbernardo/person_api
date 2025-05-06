defmodule PersonApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PersonApiWeb.Telemetry,
      PersonApi.Repo,
      {DNSCluster, query: Application.get_env(:person_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PersonApi.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PersonApi.Finch},
      # Start a worker by calling: PersonApi.Worker.start_link(arg)
      # {PersonApi.Worker, arg},
      # Start to serve requests, typically the last entry
      PersonApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PersonApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PersonApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
