defmodule ExFinchTwitch.API.Ads do
  @moduledoc false
  alias ExFinchTwitch.FinchClient

  def start_commercial(token) do
    config = Application.fetch_env!(:sudo_stream_tools, SudoStreamToolsWeb.OAuth.Twitch)

    FinchClient.build(:get, "#{config[:api_url]}/helix/users", [
      {"authorization", "Bearer #{token}"},
      {"content-type", "application/json"},
      {"client-id", config[:client_id]}
    ])
    |> FinchClient.request()
    |> case do
      {
        :ok,
        %{
          "data" => [
            %{
              "id" => platform_id,
              "display_name" => display_name,
              "profile_image_url" => profile_image_url
            }
            | _
          ]
        }
      } ->
        {
          :ok,
          %{
            "id" => platform_id,
            "display_name" => display_name,
            "profile_image_url" => profile_image_url
          }
        }

      {:error, reason} ->
        {:error, reason}
    end
  end
end
