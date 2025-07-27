defmodule ExFinchTwitch do
  alias ExFinchTwitch.Behaviour
  @behaviour Behaviour

  @moduledoc """
  Documentation for `ExFinchTwitch`.
  """

  @doc """
  Requests a Twitch application OAuth token using the client credentials flow.

  ## Parameters

    * `scope` - A space-delimited string of OAuth scopes to request.

  ## Returns

    * `{:ok, %{access_token: "abc123", expires_in: 3600, token_type: "bearer"}}` on success `t:ExFinchTwitch.Types.client_token/0`
    * `{:error, reason}` on failure

  ## Example

      ExFinchTwitch.Api.OAuthToken.get_client_token("channel:read:subscriptions")

  ## Refernce

  """
  @impl Behaviour
  defdelegate get_client_token(id), to: ExFinchTwitch.API.ClientToken
end
