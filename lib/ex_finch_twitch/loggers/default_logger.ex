defmodule ExFinchTwitch.Loggers.DefaultLogger do
  @moduledoc "Default logger using Elixir's built-in Logger."
  @behaviour ExFinchTwitch.Logger

  require Logger

  @impl true
  def info(msg), do: Logger.info("[MyLibrary] " <> msg)

  @impl true
  def warning(msg), do: Logger.warning("[MyLibrary] " <> msg)

  @impl true
  def error(msg), do: Logger.error("[MyLibrary] " <> msg)
end
