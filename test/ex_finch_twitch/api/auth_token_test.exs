defmodule ExFinchTwitch.API.AuthTokenTest do
  use ExFinchTwitch.TestCase

  test "get_client_token performs successfully", %{bypass: bypass} do
    scopes = "RIP_MY_TEST"

    expected_data = %{
          access_token: "abcdefg1234567890abcdefghijklmnopqrstuv",
          expires_in: 5_184_000,
          token_type: "bearer"
        }

    Bypass.expect_once(bypass, "POST", "/oauth2/token", fn conn ->
      {:ok, request_body, conn} = Plug.Conn.read_body(conn)

      assert request_body =~ "scope=#{scopes}"
      assert request_body =~ "client_id=#{ExFinchTwitch.Config.client_id()}"
      assert request_body =~ "client_secret=#{ExFinchTwitch.Config.client_secret()}"
      assert request_body =~ "grant_type=client_credentials"

      body = Jason.encode!(expected_data)

      Plug.Conn.resp(conn, 200, body)
    end)

    assert {:ok, expected_data} == ExFinchTwitch.get_client_token(scopes)
  end

  test "get_client_token fails with invalid client secret", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/oauth2/token", fn conn ->
      body = Jason.encode!(%{status: 400, message: "Invalid client secret"})
      Plug.Conn.resp(conn, 400, body)
    end)

    assert {:error, :bad_request} = ExFinchTwitch.get_client_token("scope1")
  end

  test "get_client_token fails with missing grant_type", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/oauth2/token", fn conn ->
      body = Jason.encode!(%{status: 400, message: "Missing required parameter grant_type"})
      Plug.Conn.resp(conn, 400, body)
    end)

    assert {:error, :bad_request} = ExFinchTwitch.get_client_token("scope1")
  end

  test "get_client_token fails with unsupported grant_type", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/oauth2/token", fn conn ->
      body = Jason.encode!(%{status: 400, message: "unsupported grant type"})
      Plug.Conn.resp(conn, 400, body)
    end)

    assert {:error, :bad_request} = ExFinchTwitch.get_client_token("scope1")
  end

  test "get_application_token fails with unsupported media type", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/oauth2/token", fn conn ->
      body = Jason.encode!(%{status: 415, message: "unsupported media type"})
      Plug.Conn.resp(conn, 415, body)
    end)

    assert {:error, :unsupported_media_type} = ExFinchTwitch.get_client_token("scope1")
  end

  test "get_application_token fails with malformed request", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/oauth2/token", fn conn ->
      body = Jason.encode!(%{status: 400, message: "invalid request"})
      Plug.Conn.resp(conn, 400, body)
    end)

    assert {:error, :bad_request} = ExFinchTwitch.get_client_token("scope1")
  end

  test "get_application_token fails with rate limit exceeded", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/oauth2/token", fn conn ->
      body = Jason.encode!(%{status: 429, message: "rate limit exceeded"})
      Plug.Conn.resp(conn, 429, body)
    end)

    assert {:error, :too_many_requests} = ExFinchTwitch.get_client_token("scope1")
  end

  test "exchange_code performs successfully", %{bypass: bypass} do
    redirect_uri = "MY_REDIRECT_URI"
    code = "MY_CODE"
    code_verifier = "MY_VERIFIER"

    expected_data = %{
          access_token: "rfx2uswqe8l4g1mkagrvg5tv0ks3",
          expires_in: 14124,
          refresh_token: "5b93chm6hdve3mycz05zfzatkfdenfspp1h1ar2xxdalen01",
          scope: [
            "channel:moderate",
            "chat:edit",
            "chat:read"
          ],
          token_type: "bearer"
        }

    Bypass.expect_once(bypass, "POST", "/oauth2/token", fn conn ->
      {:ok, request_body, conn} = Plug.Conn.read_body(conn)

      assert request_body =~ "client_id=#{ExFinchTwitch.Config.client_id()}"
      assert request_body =~ "client_secret=#{ExFinchTwitch.Config.client_secret()}"
      assert request_body =~ "code=#{code}"
      assert request_body =~ "redirect_uri=#{redirect_uri}"
      assert request_body =~ "code_verifier=#{code_verifier }"
      assert request_body =~ "grant_type=authorization_code"

      body = Jason.encode!(expected_data)

      Plug.Conn.resp(conn, 200, body)
    end)

    assert {:ok, expected_data} == ExFinchTwitch.exchange_code(code, code_verifier, redirect_uri)
  end
end
