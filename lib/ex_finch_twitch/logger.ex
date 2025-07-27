defmodule ExFinchTwitch.Logger do
    @moduledoc """
  A behaviour for loggers used by `ExFinchTwitch`.

  You can set your own logger module via config:

      config :ex_finch_twitch, :logger, MyApp.MyLogger

  ## Example 1: Simple IO.inspect Logger

      defmodule MyApp.SimpleLogger do
        @behaviour ExFinchTwitch.Logger

        @impl true
        def ex_finch_twitch_info(data), do: IO.inspect({"INFO", data})
        @impl true
        def ex_finch_twitch_warning(data), do: IO.inspect({"WARN", data})
        @impl true
        def ex_finch_twitch_error(data), do: IO.inspect({"ERROR", data})
        @impl true
        def ex_finch_twitch_fatal(data), do: IO.inspect({"FATAL", data})
      end

  ## Example 2: Sentry Logger

      defmodule MyApp.SentryLogger do
        @behaviour ExFinchTwitch.Logger

        @impl true
        def ex_finch_twitch_info(%ExFinchTwitch.LoggerArguments{message: msg, extra: extra, tags: tags}) do
          Sentry.capture_message(msg, level: :info, extra: extra, tags: tags)
        end

        @impl true
        def ex_finch_twitch_warning(%ExFinchTwitch.LoggerArguments{message: msg, extra: extra, tags: tags}) do
          Sentry.capture_message(msg, level: :warning, extra: extra, tags: tags)
        end

        @impl true
        def ex_finch_twitch_error(%ExFinchTwitch.LoggerArguments{message: msg, extra: extra, tags: tags}) do
          Sentry.capture_message(msg, level: :error, extra: extra, tags: tags)
        end

        @impl true
        def ex_finch_twitch_fatal(%ExFinchTwitch.LoggerArguments{message: msg, extra: extra, tags: tags}) do
          Sentry.capture_message(msg, level: :fatal, extra: extra, tags: tags)
        end
      end

  Set the logger module in your config like so:

      config :ex_finch_twitch, :logger, MyApp.SentryLogger
  """

  @callback ex_finch_twitch_info(ExFinchTwitch.LoggerArguments.t()) :: any()
  @callback ex_finch_twitch_warning(ExFinchTwitch.LoggerArguments.t()) :: any()
  @callback ex_finch_twitch_error(ExFinchTwitch.LoggerArguments.t()) :: any()
  @callback ex_finch_twitch_fatal(ExFinchTwitch.LoggerArguments.t()) :: any()

  @doc false
  @spec process_info_log(ExFinchTwitch.LoggerArguments.t()) :: :ok | :no_logger_configured
  def process_info_log(data) do
    case ExFinchTwitch.Config.logger() do
      nil ->
        :no_logger_configured

      logger_module ->
        logger_module.ex_finch_twitch_info(data)
        :ok
    end
  end

  @doc false
  @spec process_warning_log(ExFinchTwitch.LoggerArguments.t()) :: :ok | :no_logger_configured
  def process_warning_log(data) do
    case ExFinchTwitch.Config.logger() do
      nil ->
        :no_logger_configured

      logger_module ->
        logger_module.ex_finch_twitch_warning(data)
        :ok
    end
  end

  @doc false
  @spec process_error_log(ExFinchTwitch.LoggerArguments.t()) :: :ok | :no_logger_configured
  def process_error_log(data) do
    case ExFinchTwitch.Config.logger() do
      nil ->
        :no_logger_configured

      logger_module ->
        logger_module.ex_finch_twitch_error(data)
        :ok
    end
  end

  @doc false
  @spec process_fatal_log(ExFinchTwitch.LoggerArguments.t()) :: :ok | :no_logger_configured
  def process_fatal_log(data) do
    case ExFinchTwitch.Config.logger() do
      nil ->
        :no_logger_configured

      logger_module ->
        logger_module.ex_finch_twitch_fatal(data)
        :ok
    end
  end
end
