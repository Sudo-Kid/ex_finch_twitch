defmodule ExFinchTwitch.Behaviour do
  @moduledoc false

  @callback get_client_token(String.t()) :: {:ok, ExFinchTwitch.Types.client_token()} | {:error, any()}
  @callback exchange_code(String.t(), String.t(), String.t()) :: {:ok, ExFinchTwitch.Types.user_token()} | {:error, any()}
end
