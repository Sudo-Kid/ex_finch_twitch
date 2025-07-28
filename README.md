# ExFinchTwitch

A simple HTTP client for interacting with the Twitch API using Finch.

## Features

- Finch based Twitch wrapper
- Bypass support for mocking in tests
- Configurable base URL and API key

## Installation

```elixir
def deps do
  [
    {:ex_finch_twitch, "~> 0.0.1"}
  ]
end
```

## Config

```
config :my_library,
  client_id: "MY_TEST_CLIENT_ID_KEY",
  client_secret: "MY_TEST_CLIENT_SECRET"
```