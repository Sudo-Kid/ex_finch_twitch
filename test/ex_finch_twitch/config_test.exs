defmodule ExFinchTwitch.ConfigTest do
  # use ExUnit.Case, async: true
  use ExFinchTwitch.TestCase

  alias ExFinchTwitch.Config

  @app :ex_finch_twitch

  test "checks all configs", %{bypass: bypass} do
    assert Application.get_env(@app, :client_id) == "MY_TEST_CLIENT_KEY"
    assert Application.get_env(@app, :token_url) == "http://localhost:#{bypass.port}"
    assert Application.get_env(@app, :api_url) == "http://localhost:#{bypass.port}"
  end
end
