defmodule ElixirAuthGoogle do
  @moduledoc """
  Minimalist Google OAuth Authentication for Elixir Apps
  """

  def login_url do
    client_id = Application.fetch_env!(:elixir_auth_google, :google_client_id)
    "Google url for the application with client id: #{client_id}"
  end
end
