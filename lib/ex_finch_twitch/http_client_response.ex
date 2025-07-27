defmodule ExFinchTwitch.HttpClientResponse do
  @moduledoc false
  @enforce_keys [:status_code, :headers, :body]
  defstruct [
    :status_code,
    :headers,
    :body
  ]

  @typedoc "An Http Client Response"
  @type t :: %__MODULE__{
          status_code: pos_integer(),
          headers: %{optional(String.t()) => String.t()},
          body: String.t()
        }
end
