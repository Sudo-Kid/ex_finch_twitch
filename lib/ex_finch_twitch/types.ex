defmodule ExFinchTwitch.Types do
  @moduledoc """
  Shared types used throughout ExFinchTwitch.

  This module defines public types like `t:client_token/0`.
  """

  @typedoc """
  Represents a Twitch OAuth2 application token.

  ## Fields

    * `:access_token` - The OAuth2 bearer token returned by Twitch.
    * `:expires_in` - The lifetime of the token in seconds.
    * `:token_type` - The type of the token, typically "bearer".

  ## Example

    %{
      access_token: "abc123",
      expires_in: 3600,
      token_type: "bearer"
    }
  """
  @type client_token :: %{
          access_token: String.t(),
          expires_in: pos_integer(),
          token_type: String.t()
        }

  @typedoc """
  Represents a Twitch OAuth2 user access token.

  ## Fields

    * `:access_token` - The OAuth2 bearer token granted to the user.
    * `:expires_in` - The number of seconds until the token expires.
    * `:refresh_token` - A token that can be used to obtain a new access token.
    * `:scope` - A list of scopes granted with the token.
    * `:token_type` - The type of token, usually `"bearer"`.

  ## Example

      %{
        access_token: "user123token",
        expires_in: 3600,
        refresh_token: "refresh456token",
        scope: ["user:read:email", "channel:read:subscriptions"],
        token_type: "bearer"
      }
  """
  @type user_token :: %{
          access_token: String.t(),
          expires_in: pos_integer(),
          refresh_token: String.t(),
          scope: [String.t()],
          token_type: String.t()
        }

  @typedoc """
  Subscription status.

  Possible values:
  - `:enabled` – Subscription is active and sending notifications.
  - `:webhook_callback_verification_pending` – Twitch is waiting for you to respond to the challenge.
  - `:webhook_callback_verification_failed` – You failed to respond correctly or in time.
  - `:notification_failures_exceeded` – Too many failed delivery attempts.
  - `:authorization_revoked` – OAuth token was revoked or expired.
  - `:moderator_removed` – The moderator who created the subscription was removed.
  - `:user_removed` – The user who created the subscription was removed.
  """
  @type status ::
          :enabled
          | :webhook_callback_verification_pending
          | :webhook_callback_verification_failed
          | :notification_failures_exceeded
          | :authorization_revoked
          | :moderator_removed
          | :user_removed

  @typedoc """
  Twitch EventSub subscription type as an atom.

  Use these atom variants to refer to subscription types in a safer, more Elixir-friendly way.

  Examples:
    - `:channel__follow`
    - `:channel__subscribe`
    - `:channel__raid`
    - `:channel__update`
    - `:channel__moderator_add`
    - `:channel__chat__message`
    - `:stream__online`
    - `:stream__offline`

  These map directly to the EventSub string types (e.g., `"channel.chat.clear_user_messages"` becomes `:channel__chat__clear_user_messages`).

  Full list of possible types:
  https://dev.twitch.tv/docs/eventsub/eventsub-subscription-types/
  """
  @type subscription_type ::
          :channel__update
          | :channel__follow
          | :channel__moderator__add
          | :channel__moderator__remove
          | :channel__subscribe
          | :channel__subscription__end
          | :channel__subscription__gift
          | :channel__subscription__message
          | :channel__cheer
          | :channel__raid
          | :channel__ban
          | :channel__unban
          | :channel__message__delete
          | :channel__unraid
          | :channel__poll__begin
          | :channel__poll__progress
          | :channel__poll__end
          | :channel__prediction__begin
          | :channel__prediction__progress
          | :channel__prediction__lock
          | :channel__prediction__end
          | :channel__goal__begin
          | :channel__goal__progress
          | :channel__goal__end
          | :channel__hype_train__begin
          | :channel__hype_train__progress
          | :channel__hype_train__end
          | :stream__online
          | :stream__offline
          | :user__authorization__grant
          | :user__authorization__revoke
          | :user__update
          | :channel__shield_mode__begin
          | :channel__shield_mode__end
          | :channel__shoutout__create
          | :channel__shoutout__receive
          | :channel__guest_star_session__begin
          | :channel__guest_star_session__end
          | :channel__guest_star__guest__update
          | :channel__guest_star__guest__add
          | :channel__guest_star__guest__remove
          | :channel__guest_star__guest_slot__update
          | :channel__chat__message
          | :channel__chat__notification
          | :automod__message__hold
          | :automod__message__update

  @typedoc """
  Query parameters allowed for fetching EventSub subscriptions.
  """
  @type event_sub_query_parameters :: %{
          status: status() | nil,
          type: subscription_type() | nil,
          user_id: String.t() | nil,
          after: String.t() | nil,
          first: pos_integer() | nil
        }

  @doc """
  Converts the struct into a keyword list suitable for URI encoding in an HTTP query.

  Converts atoms like `:enabled` into string form automatically.
  """
  def to_query(%{} = params) do
    params
    |> Map.from_struct()
    |> Enum.filter(fn {_k, v} -> v != nil end)
    |> Enum.map(fn
      {:status, atom} when is_atom(atom) ->
        "status=#{Atom.to_string(atom)}"

      {:type, atom} when is_atom(atom) ->
        "type=#{Atom.to_string(atom) |> String.replace("__", ".")}"

      {k, v} when is_atom(k) ->
        "#{Atom.to_string(k)}=#{v}"
    end)
    |> Enum.join("&")
  end
end
