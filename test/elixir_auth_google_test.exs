defmodule ElixirAuthGoogleTest do
  use ExUnit.Case
  doctest ElixirAuthGoogle

  test "get Google login url" do
    Application.put_env(:elixir_auth_google, :google_client_id, 123)
    assert ElixirAuthGoogle.generate_oauth_url() =~ "https://accounts.google.com/o/oauth2/v2/auth?response_type=code"
  end
end
