defmodule ExFinchTwitch do
  alias Module.Behaviour
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

    * `{:ok, %{access_token: String.t(), expires_in: integer(), token_type: String.t()}}` on success
    * `{:error, reason}` on failure

  ## Example

      ExFinchTwitch.Api.OAuthToken.get_client_token("channel:read:subscriptions")

  """
  @impl Behaviour
  defdelegate get_client_token(id), to: ExFinchTwitch.API.AuthToken

  @doc """
  Exchanges an OAuth 2.0 authorization code for an access token.

  This function implements the final step of the OAuth Authorization Code Flow by
  sending a `POST` request to Twitch's `/oauth2/token` endpoint. It returns an access
  token and related metadata if the exchange is successful.

  ## Parameters

    * `code` - The authorization code received from Twitch after user authorization.
    * `code_verifier` - The original code verifier used during the PKCE code challenge step.
    * `redirect_uri` - The redirect URI that was used in the authorization request. Must exactly match.

  ## Returns

    * `{:ok, %{access_token: String.t(), expires_in: integer(), refresh_token: String.t(), scope: [String.t()], token_type: String.t()}}`
      on success.
    * `{:error, reason}` on failure (e.g. invalid code, mismatched redirect URI, network error).

  ## Example

      exchange_code("abc123", "secret_code_verifier", "https://myapp.com/auth/twitch/callback")

  """
  @impl Behaviour
  defdelegate exchange_code(code, code_verifier, redirect_uri), to: ExFinchTwitch.API.AuthToken
end
