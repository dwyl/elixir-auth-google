defmodule ElixirAuthGoogle do
  @moduledoc """
  Minimalist Google OAuth Authentication for Elixir Apps.
  Extensively tested, documented, maintained and in active use in production.
  """
  @httpoison Application.get_env(:elixir_auth_google, :httpoison) || HTTPoison
  @google_auth_url "https://accounts.google.com/o/oauth2/v2/auth?response_type=code"
  @google_token_url "https://oauth2.googleapis.com/token"
  @google_user_profile "https://www.googleapis.com/oauth2/v3/userinfo"


  @doc """
  `get_baseurl_from_conn/1` derives the base URL from the conn struct
  """
  @spec get_baseurl_from_conn(Map) :: String.t
  def get_baseurl_from_conn(%{host: h, port: p}) when h == "localhost" do
    "http://#{h}:#{p}"
  end

  def get_baseurl_from_conn(%{host: h}) do
     "https://#{h}"
  end


  @doc """
  `generate_redirect_uri/1` generates the Google redirect uri based on conn
  """
  @spec generate_redirect_uri(Map) :: String.t
  def generate_redirect_uri(conn) do
    get_baseurl_from_conn(conn) <> "/auth/google/callback"
  end

  @doc """
  `generate_redirect_uri/2` generates the Google redirect uri based on conn and callback endpoint
  """
  def generate_redirect_uri(conn, callback_endpoint) when is_binary(callback_endpoint) do
    get_baseurl_from_conn(conn) <> "/" <> callback_endpoint
  end

  @doc """
  `generate_oauth_url/1` creates the Google OAuth2 URL with client_id, scope and
  redirect_uri which is the URL Google will redirect to when auth is successful.
  This is the URL you need to use for your "Login with Google" button.
  See step 5 of the instructions.
  """
  @spec generate_oauth_url(Map) :: String.t
  def generate_oauth_url(conn) do
    client_id = System.get_env("GOOGLE_CLIENT_ID")
    scope = System.get_env("GOOGLE_SCOPE") || "profile email"
    redirect_uri = generate_redirect_uri(conn)

    "#{@google_auth_url}&client_id=#{client_id}&scope=#{scope}&redirect_uri=#{redirect_uri}"
  end

  @doc """
  `generate_oauth_url/2` creates the Google OAuth2 URL with client_id, scope and
  redirect_uri using the callbac_endpoint parameter
  """
  def generate_oauth_url(conn, callback_endpoint) do
    client_id = System.get_env("GOOGLE_CLIENT_ID")
    scope = System.get_env("GOOGLE_SCOPE") || "profile email"
    redirect_uri = generate_redirect_uri(conn, callback_endpoint)

    "#{@google_auth_url}&client_id=#{client_id}&scope=#{scope}&redirect_uri=#{redirect_uri}"
  end
  @doc """
  `get_token/2` encodes the secret keys and authorization code returned by Google
  and issues an HTTP request to get a person's profile data.

  **TODO**: we still need to handle the various failure conditions >> issues/16
  """
  @spec get_token(String.t, Map) :: String.t
  def get_token(code, conn) do
    body = Poison.encode!(
      %{ client_id: System.get_env("GOOGLE_CLIENT_ID"),
         client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
         redirect_uri: generate_redirect_uri(conn),
         grant_type: "authorization_code",
         code: code
    })

    @httpoison.post(@google_token_url, body)
    |> parse_body_response()
  end

  @doc """
  `get_user_profile/1` requests the Google User's userinfo profile data
  providing the access_token received in the `get_token/1` above.
  invokes `parse_body_response/1` to decode the JSON data.

  **TODO**: we still need to handle the various failure conditions >> issues/16
  At this point the types of errors we expect are HTTP 40x/50x responses.
  """
  @spec get_user_profile(String.t) :: String.t
  def get_user_profile(token) do
    "#{@google_user_profile}?access_token=#{token}"
    |> @httpoison.get()
    |> parse_body_response()
  end

  @doc """
  `parse_body_response/1` parses the response returned by Google
  so your app can use the resulting JSON.
  """
  @spec parse_body_response({atom, String.t}) :: String.t
  def parse_body_response({:error, err}), do: {:error, err}
  def parse_body_response({:ok, response}) do
    body = Map.get(response, :body)
    if body == nil do
      {:error, :no_body}
    else # make keys of map atoms for easier access in templates
      {:ok, str_key_map} = Poison.decode(body)
      atom_key_map = for {key, val} <- str_key_map, into: %{},
        do: {String.to_atom(key), val}
      {:ok, atom_key_map}
    end # https://stackoverflow.com/questions/31990134
  end
end
