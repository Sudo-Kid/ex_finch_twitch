defmodule ExFinchTwitch.HttpClientResponse do
  @moduledoc """
  Represents a Http Client Response
  """

  @enforce_keys [:status_code, :headers, :body]
  defstruct [
    :status_code,
    :headers,
    :body
  ]

  @typedoc "An Http Client Response"
  @type t :: %__MODULE__{
          status_code: Integer.t(),
          headers: %{optional(String.t()) => String.t()},
          body: String.t()
        }
end
