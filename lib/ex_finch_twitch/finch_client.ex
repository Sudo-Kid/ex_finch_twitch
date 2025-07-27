defmodule ExFinchTwitch.FinchAPIClient.FinchClient do
  @moduledoc false
  alias ExFinchTwitch.Types.LoggerArgumentType
  alias ExFinchTwitch.HttpClientResponse

  def build(method, url, headers \\ [], body \\ nil) do
    Finch.build(method, url, headers, body)
  end

  def request(request, opts \\ []) do
    case Finch.request(request, __MODULE__, opts) |> process_response do
      %HttpClientResponse{status_code: status_code, body: body}
      when status_code in 200..299 ->
        {:ok, Jason.decode!(body)}

      %HttpClientResponse{status_code: 429, headers: headers, body: _body} ->
        ExFinchTwitch.Logger.process_fatal_log(%ExFinchTwitch.LoggerArguments{
          message: "Rate limit hit. Retrying in #{headers["ratelimit-reset"]} second",
          extra: %{
            status_code: 429,
            ratlimit_reset: headers["ratelimit-reset"],
            ratelimit: headers["ratelimit-limit"]
          },
          tags: %{module: "TwitchClient"}
        })

        {:error, :too_many_requests}

      %HttpClientResponse{status_code: 415, headers: _headers, body: _body} ->
        # Sentry.capture_message(
        #   "Unsupported media type",
        #   level: :fatal,
        #   extra: %{
        #     status_code: 415
        #   },
        #   tags: %{module: "TwitchClient"}
        # )

        {:error, :unsupported_media_type}

      %HttpClientResponse{status_code: status_code, headers: _headers, body: body}
      when status_code in 400..499 ->
        # Sentry.capture_message("Bad request",
        #   level: :error,
        #   extra: %{status_code: status_code, body: body},
        #   tags: %{module: "TwitchClient"}
        # )

        {:error, :bad_request}

      %HttpClientResponse{status_code: 500, headers: _headers, body: body} ->
        # Sentry.capture_message("Internal Server Error",
        #   level: :error,
        #   extra: %{status_code: 500, body: body},
        #   tags: %{module: "TwitchClient"}
        # )

        {:error, :internal_server_error}

      %HttpClientResponse{status_code: 502, headers: _headers, body: body} ->
        # Sentry.capture_message("Bad Gateway",
        #   level: :error,
        #   extra: %{status_code: 502, body: body},
        #   tags: %{module: "TwitchClient"}
        # )

        {:error, :bad_gateway}

      %HttpClientResponse{status_code: 503, headers: _headers, body: body} ->
        # Sentry.capture_message("Service Unavailable",
        #   level: :error,
        #   extra: %{status_code: 503, body: body},
        #   tags: %{module: "TwitchClient"}
        # )

        {:error, :service_unavailable}

      %HttpClientResponse{status_code: 504, headers: _headers, body: body} ->
        # Sentry.capture_message("Gateway Timeout",
        #   level: :error,
        #   extra: %{status_code: 504, body: body},
        #   tags: %{module: "TwitchClient"}
        # )

        {:error, :gateway_timeout}

      %HttpClientResponse{status_code: 508, headers: _headers, body: body} ->
        # Sentry.capture_message("Loop Detected",
        #   level: :error,
        #   extra: %{status_code: 508, body: body},
        #   tags: %{module: "TwitchClient"}
        # )

        {:error, :loop_detected}

      %HttpClientResponse{status_code: status_code, headers: _headers, body: body} ->
        # Sentry.capture_message("Unknow bad request",
        #   level: :error,
        #   extra: %{status_code: status_code, body: body},
        #   tags: %{module: "TwitchClient"}
        # )

        {:error, :bad_request}

      {:error, _reason} ->
        {:error, :request_failed}
    end
  end

  defp process_response({:ok, %Finch.Response{status: code, headers: headers, body: body}}) do
    headers_map =
      Enum.reduce(headers, %{}, fn {key, val}, acc ->
        Map.put(acc, String.downcase(key), val)
      end)

    %HttpClientResponse{status_code: code, headers: headers_map, body: body}
  end

  defp process_response({:error, reason}) do
    # Sentry.capture_message("Finch Error",
    #   level: :error,
    #   extra: %{reason: reason},
    #   tags: %{module: "TwitchClient"}
    # )

    {:error, {:request_failed, reason}}
  end
end
