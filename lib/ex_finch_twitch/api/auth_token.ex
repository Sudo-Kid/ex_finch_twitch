defmodule ExFinchTwitch.API.AuthToken do
  @moduledoc false

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

  def exchange_code(code, code_verifier, redirect_uri) do
    ExFinchTwitch.FinchClient.build(
      :post,
      "#{ExFinchTwitch.Config.token_url()}/oauth2/token",
      [{"content-type", "application/x-www-form-urlencoded"}],
      URI.encode_query(%{
        client_id: ExFinchTwitch.Config.client_id(),
        client_secret: ExFinchTwitch.Config.client_secret(),
        code: code,
        grant_type: "authorization_code",
        redirect_uri: redirect_uri,
        code_verifier: code_verifier
      })
    )
    |> ExFinchTwitch.FinchClient.request()
    |> case do
      {:ok,
       %{
         "access_token" => access_token,
         "expires_in" => expires_in,
         "refresh_token" => refresh_token,
         "scope" => scope,
         "token_type" => token_type
       }} ->
        {
          :ok,
          %{
            access_token: access_token,
            expires_in: expires_in,
            refresh_token: refresh_token,
            scope: scope,
            token_type: token_type
          }
        }

      {:error, reason} ->
        {:error, reason}
    end
  end
end
