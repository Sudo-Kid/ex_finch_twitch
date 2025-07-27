defmodule ExFinchTwitch.LoggerArguments do
  @typedoc "Logger argument structure including message, extra metadata, and tags"
  @type t :: %__MODULE__{
          message: String.t(),
          extra: logger_extra(),
          tags: %{module: String.t()}
        }
  defstruct [:message, :extra, :tags]

  @typedoc "Structured logging metadata for different HTTP failure types."
  @type logger_extra ::
          unsupported_media_extra()
          | rate_limit_extra()
          | internal_server_error_extra()
          | bad_gateway_extra()
          | service_unavailable_extra()
          | gateway_timeout_extra()
          | loop_detected_extra()
          | client_error_extra()
          | unknown_error_extra()
          | finch_error_extra()

  @typedoc "415 Unsupported Media Type"
  @type unsupported_media_extra :: %{
          status_code: 415
        }

  @typedoc "429 Too Many Requests"
  @type rate_limit_extra :: %{
          status_code: 429,
          ratelimit_reset: String.t(),
          ratelimit: String.t()
        }

  @typedoc "500 Internal Server Error"
  @type internal_server_error_extra :: %{
          status_code: 500,
          body: String.t()
        }

  @typedoc "502 Bad Gateway"
  @type bad_gateway_extra :: %{
          status_code: 502,
          body: String.t()
        }

  @typedoc "503 Service Unavailable"
  @type service_unavailable_extra :: %{
          status_code: 503,
          body: String.t()
        }

  @typedoc "504 Gateway Timeout"
  @type gateway_timeout_extra :: %{
          status_code: 504,
          body: String.t()
        }

  @typedoc "508 Loop Detected"
  @type loop_detected_extra :: %{
          status_code: 508,
          body: String.t()
        }

  @typedoc "Generic client-side error (400–499)"
  @type client_error_extra :: %{
          status_code: 400..499,
          body: String.t()
        }

  @typedoc "Fallback for unknown server/client errors"
  @type unknown_error_extra :: %{
          status_code: pos_integer(),
          body: String.t()
        }

  @typedoc "Finch transport-level error (no HTTP response)"
  @type finch_error_extra :: %{
          reason: term()
        }
end
