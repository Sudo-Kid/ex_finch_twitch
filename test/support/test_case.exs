defmodule ExFinchTwitch.TestCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use ExUnit.Case, async: false
      import Plug.Conn

      setup _tags do
        bypass = Bypass.open()
        Application.put_env(:ex_finch_twitch, :token_url, "http://localhost:#{bypass.port}")
        Application.put_env(:ex_finch_twitch, :api_url, "http://localhost:#{bypass.port}")
        Application.put_env(:ex_finch_twitch, :client_id, "MY_TEST_CLIENT_KEY")
        Application.put_env(:ex_finch_twitch, :client_secret, "MY_TEST_CLIENT_SECRET")
        {:ok, bypass: bypass}
      end
    end
  end
end
