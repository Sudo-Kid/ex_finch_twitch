defmodule ExFinchTwitch.Logger do
  @moduledoc """
  A behavior for loggers used by `MyLibrary`.

  You can set your own logger module via config:

      config :ex_finch_twitch, :logger, MyApp.MyLogger
  """

  @callback info(String.t()) :: any()

  @doc """
  Deprecated. Use `warning/1` instead.

  ## Deprecated
  """
  @callback warn(String.t()) :: any()
  @callback warning(String.t()) :: any()
  @callback error(String.t()) :: any()
end
