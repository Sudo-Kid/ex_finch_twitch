defmodule ExFinchTwitch.Application do
  @doc false
  use Application

  def start(_type, _args) do
    children = [
      {Finch, name: ExFinchTwitch.FinchClient}
    ]

    opts = [strategy: :one_for_one, name: ExFinchTwitch.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
