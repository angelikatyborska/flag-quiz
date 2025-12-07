defmodule FlagQuiz.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FlagQuizWeb.Telemetry,
      FlagQuiz.Repo,
      {DNSCluster, query: Application.get_env(:flag_quiz, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FlagQuiz.PubSub},
      # Start a worker by calling: FlagQuiz.Worker.start_link(arg)
      # {FlagQuiz.Worker, arg},
      # Start to serve requests, typically the last entry
      FlagQuizWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FlagQuiz.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FlagQuizWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
