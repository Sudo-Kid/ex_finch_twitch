defmodule ExFinchTwitch.Config do
  @moduledoc """
  Handles runtime configuration for `ExFinchTwitch`.

  To configure the library, add the following to your `config/config.exs`:

      config :ex_finch_twitch,
        client_id: "MY_CLIENT_ID",
        client_secret: "MY_CLIENT_SECRET",
        logger: MyApp.CustomLogger

  ## Configuration Options

    * `:client_id` - The Twitch API client ID.
    * `:client_secret` - The Twitch API client secret.
    * `:logger` - (Optional) A module that implements the logging behavior.
  """

  @app :ex_finch_twitch

  @doc false
  def token_url do
    # Mainly here for bypass testing
    Application.get_env(@app, :token_url, "https://id.twitch.tv")
  end

  @doc false
  def api_url do
    # Mainly here for bypass testing
    Application.get_env(@app, :api_url, "https://api.twitch.tv")
  end

  @doc """
  Retrieves the configured Twitch client ID.

  Falls back to `"MY_TEST_CLIENT_ID"` if not set.
  """
  def client_id do
    Application.get_env(@app, :client_id, "MY_TEST_CLIENT_ID")
  end

  @doc """
  Retrieves the configured Twitch client secret.

  Falls back to `"MY_TEST_CLIENT_SECRET"` if not set.
  """
  def client_secret do
    Application.get_env(@app, :client_secret, "MY_TEST_CLIENT_SECRET")
  end

  @doc """
  Returns the logger module configured for the library.

  Defaults to no logging if not explicitly set.
  """
  def logger do
    Application.get_env(@app, :logger, nil)
  end
end
