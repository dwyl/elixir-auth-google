defmodule ElixirAuthGoogle do
  @moduledoc """
  Minimalist Google OAuth Authentication for Elixir Apps
  """
  @google_auth_url "https://accounts.google.com/o/oauth2/v2/auth?response_type=code"
  @google_token_url "https://oauth2.googleapis.com/token"
  @google_user_profile "https://www.googleapis.com/auth/userinfo.profile"

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

  def get_user_profile(token) do
    "#{@google_user_profile}?access_token=#{token}"
    |> HTTPoison.get!()
    |> Map.fetch!(:body)
    |> Poison.decode!()
  end
end
