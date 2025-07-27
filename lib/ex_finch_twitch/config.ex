defmodule ExFinchTwitch.Config do
  @moduledoc """
  Handles configuration for MyLibrary.
  """

  @app :ex_finch_twitch

  def token_url do
    # Mainly here for bypass testing
    Application.get_env(@app, :token_url, "https://id.twitch.tv")
  end

  def api_url do
    # Mainly here for bypass testing
    Application.get_env(@app, :api_url, "https://api.twitch.tv")
  end

  def client_id do
    Application.get_env(@app, :client_id, "MY_TEST_CLIENT_KEY")
  end

  def client_secret do
    Application.get_env(@app, :client_secret, "MY_TEST_CLIENT_SECRET")
  end

  def logger do
    Application.get_env(@app, :logger, ExFinchTwitch.Loggers.DefaultLogger) # Default to Logger
  end
end
