defmodule ExFinchTwitch.ConfigTest do
  # use ExUnit.Case, async: true
  use ExFinchTwitch.TestCase

  alias ExFinchTwitch.Config

  test "checks all configs", %{bypass: bypass} do
    assert Config.client_id() == "MY_TEST_CLIENT_KEY"
    assert Config.client_secret() == "MY_TEST_CLIENT_SECRET"
    assert Config.token_url() == "http://localhost:#{bypass.port}"
    assert Config.api_url() == "http://localhost:#{bypass.port}"
  end
end
