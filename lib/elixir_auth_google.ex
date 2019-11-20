defmodule ElixirAuthGoogle do
  @moduledoc """
  Minimalist Google OAuth Authentication for Elixir Apps
  """
  @google_url "https://accounts.google.com/o/oauth2/v2/auth?response_type=code"

  def generate_oauth_url do
    client_id = Application.get_env(:elixir_auth_google, :google_client_id)
    scope = Application.get_env(:elixir_auth_google, :google_scope ) || "profile"
    redirect_uri = Application.get_env(:elixir_auth_google, :google_redirect_uri)

    "#{@google_url}&client_id=#{client_id}&scope=#{scope}&redirect_uri=#{redirect_uri}"
  end
end
