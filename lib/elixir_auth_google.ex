defmodule ElixirAuthGoogle do
  @moduledoc """
  Minimalist Google OAuth Authentication for Elixir Apps
  """
  @httpoison Application.get_env(:elixir_auth_google, :httpoison) || HTTPoison
  @google_auth_url "https://accounts.google.com/o/oauth2/v2/auth?response_type=code"
  @google_token_url "https://oauth2.googleapis.com/token"
  @google_user_profile "https://www.googleapis.com/oauth2/v3/userinfo"

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

    @httpoison.post(@google_token_url, body)
    |> parse_body_response()
  end

  def get_user_profile(token) do
    "#{@google_user_profile}?access_token=#{token}"
    |> @httpoison.get()
    |> parse_body_response()
  end

  defp parse_body_response({:error, err}), do: {:error, err}
  defp parse_body_response({:ok, response}) do
    body = Map.get(response, :body)
    if body == nil do
      {:error, :no_body}
    else
      Poison.decode(body)
    end
  end

end
