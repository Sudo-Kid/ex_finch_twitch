defmodule ExFinchTwitch.API.ClientToken do
  @moduledoc false

  @doc """
  Requests a Twitch application OAuth token using the client credentials flow.

  ## Parameters

    * `scope` – A space-delimited string of OAuth scopes to request.

  ## Returns

    * `{:ok, `t:ExFinchTwitch.Types.client_token/0`}` on success
    * `{:error, reason}` on failure

  ## Example

      ExFinchTwitch.Api.OAuthToken.get_client_token("channel:read:subscriptions")
  """
  @spec get_client_token(any()) ::
          {:error,
           :bad_gateway
           | :bad_request
           | :gateway_timeout
           | :internal_server_error
           | :loop_detected
           | :request_failed
           | :service_unavailable
           | :unsupported_media_type}
          | {:ok, %{access_token: any(), expires_in: any(), token_type: any()}}
  def get_client_token(scope) do
    ExFinchTwitch.FinchClient.build(
      :post,
      "#{ExFinchTwitch.Config.token_url()}/oauth2/token",
      [{"content-type", "application/x-www-form-urlencoded"}],
      URI.encode_query(%{
        client_id: ExFinchTwitch.Config.client_id(),
        client_secret: ExFinchTwitch.Config.client_secret(),
        grant_type: "client_credentials",
        scope: scope
      })
    )
    |> ExFinchTwitch.FinchClient.request()
    |> case do
      {:ok,
       %{"access_token" => access_token, "expires_in" => expires_in, "token_type" => token_type}} ->
        {:ok, %{access_token: access_token, expires_in: expires_in, token_type: token_type}}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
