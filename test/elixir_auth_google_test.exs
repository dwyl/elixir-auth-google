defmodule ElixirAuthGoogleTest do
  use ExUnit.Case
  doctest ElixirAuthGoogle

  test "get Google login url" do
    Application.put_env(:elixir_auth_google, :google_client_id, 123)
    assert ElixirAuthGoogle.generate_oauth_url() =~ "https://accounts.google.com/o/oauth2/v2/auth?response_type=code"
  end

  test "get Google token" do
    assert ElixirAuthGoogle.get_token("ok_code") == {:ok, %{"access_token" => "token1"}}
  end

  test "get user profile" do
    assert ElixirAuthGoogle.get_user_profile("123") == {:ok, %{"name" => "dwyl"}}
  end

  test "return error with incorrect token" do
    assert ElixirAuthGoogle.get_user_profile("wrong_token") == {:error, :bad_request }
  end
end
