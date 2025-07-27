defmodule ExFinchTwitch.Application do
  use Application

  def start(_type, _args) do
    # Don't supervise Finch here
    children = [
      {Finch, name: ExFinchTwitch.FinchAPIClient.FinchClient}
    ]

    opts = [strategy: :one_for_one, name: ExFinchTwitch.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
