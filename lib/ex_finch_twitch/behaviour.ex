defmodule ExFinchTwitch.Behaviour do
  @moduledoc false

  @callback get_client_token(String.t()) :: {:ok, ExFinchTwitch.Types.client_token()} | {:error, any()}
end
