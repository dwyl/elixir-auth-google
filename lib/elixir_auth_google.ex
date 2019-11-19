defmodule ElixirAuthGoogle do
  @moduledoc """
  Minimalist Google OAuth Authentication for Elixir Apps
  """
  @google_auth_url "https://accounts.google.com/o/oauth2/v2/auth?response_type=code"
  @google_token_url "https://oauth2.googleapis.com/token"

  def generate_oauth_url do
    client_id = Application.get_env(:elixir_auth_google, :google_client_id)
    scope = Application.get_env(:elixir_auth_google, :google_scope ) || "profile"
    redirect_uri = Application.get_env(:elixir_auth_google, :google_redirect_uri)

    "#{@google_auth_url}&client_id=#{client_id}&scope=#{scope}&redirect_uri=#{redirect_uri}"
  end

  def get_token(code) do
    body = Poison.encode!(
      %{ client_id: Application.get_env(:elixir_auth_google, :google_client_id),
         client_secret: Application.get_env(:elixir_auth_google, :google_client_secret),
         redirect_uri: Application.get_env(:elixir_auth_google, :google_redirect_uri),
         grant_type: "authorization_code",
         code: code
    })

    HTTPoison.post!(@google_token_url, body)
    |> Map.fetch!(:body)
    |> Poison.decode!()
  end
end
