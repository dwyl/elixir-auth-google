defmodule ElixirAuthGoogleTest do
  use ExUnit.Case
  doctest ElixirAuthGoogle

  test "get Google login url" do
    Application.put_env(:elixir_auth_google, :client_id, 123)
    assert ElixirAuthGoogle.login_url() == "Google url for the application with client id: 123"
  end
end
