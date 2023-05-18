defmodule ElixirAuthGoogle do
  @moduledoc """
  Minimalist Google OAuth Authentication for Elixir Apps.
  Extensively tested, documented, maintained and in active use in production.
  """
  @google_auth_url "https://accounts.google.com/o/oauth2/v2/auth?response_type=code"
  @google_token_url "https://oauth2.googleapis.com/token"
  @google_user_profile "https://www.googleapis.com/oauth2/v3/userinfo"
  @default_scope "profile email"
  @default_callback_path "/auth/google/callback"

  @httpoison (Application.compile_env(:elixir_auth_google, :httpoison_mock) &&
                ElixirAuthGoogle.HTTPoisonMock) || HTTPoison

  @type conn :: map
  @type url :: String.t()

  @doc """
  `inject_poison/0` injects a TestDouble of HTTPoison in Test
  so that we don't have duplicate mock in consuming apps.
  see: github.com/dwyl/elixir-auth-google/issues/35
  """
  def inject_poison, do: @httpoison

  @doc """
  `get_baseurl_from_conn/1` derives the base URL from the conn struct
  """
  @spec get_baseurl_from_conn(conn) :: String.t()
  def get_baseurl_from_conn(%{host: h, port: p, scheme: s}) when p != 80 do
    "#{Atom.to_string(s)}://#{h}:#{p}"
  end

  def get_baseurl_from_conn(%{host: h, scheme: s}) do
    "#{Atom.to_string(s)}://#{h}"
  end

  def get_baseurl_from_conn(%{host: h} = conn) do
    scheme =
      case h do
        "localhost" -> :http
        _ -> :https
      end

    get_baseurl_from_conn(Map.put(conn, :scheme, scheme))
  end

  @doc """
  `generate_redirect_uri/1` generates the Google redirect uri based on `conn`
  or the `url`. If the `App.Endpoint.url()`
  e.g: auth.dwyl.com or https://gcal.fly.dev
  is passed into `generate_redirect_uri/1`,
  return that `url` with the callback appended to it.
  See: github.com/dwyl/elixir-auth-google/issues/94
  """
  @spec generate_redirect_uri(url) :: String.t()
  def generate_redirect_uri(url) when is_binary(url) do
    scheme =
      cond do
        # url already contains scheme return empty
        String.contains?(url, "https") -> ""
        # url contains ":" is localhost:4000 no need for scheme
        String.contains?(url, ":") -> ""
        # Default to https if scheme not set e.g: app.fly.dev -> https://app.fly.fev
        true -> "https://"
      end

    "#{scheme}#{url}" <> get_app_callback_url()
  end

  @spec generate_redirect_uri(conn) :: String.t()
  def generate_redirect_uri(conn) do
    get_baseurl_from_conn(conn) <> get_app_callback_url()
  end

  @doc """
  `generate_oauth_url/1` creates the Google OAuth2 URL with client_id, scope and
  redirect_uri which is the URL Google will redirect to when auth is successful.
  This is the URL you need to use for your "Login with Google" button.
  See step 5 of the instructions.
  """
  def generate_oauth_url(url) when is_binary(url) do
    query = %{
      client_id: google_client_id(),
      scope: google_scope(),
      redirect_uri: generate_redirect_uri(url)
    }

    params = URI.encode_query(query, :rfc3986)

    "#{@google_auth_url}&#{params}"
  end

  @spec generate_oauth_url(conn) :: String.t()
  def generate_oauth_url(conn) when is_map(conn) do
    query = %{
      client_id: google_client_id(),
      scope: google_scope(),
      redirect_uri: generate_redirect_uri(conn)
    }

    params = URI.encode_query(query, :rfc3986)

    "#{@google_auth_url}&#{params}"
  end

  @doc """
  Same as `generate_oauth_url/1` with `state` query parameter,
  or a `map` of key/pair values to be included in the urls query string.
  """
  @spec generate_oauth_url(conn, String.t() | map) :: String.t()
  def generate_oauth_url(conn, state) when is_binary(state) do
    params = URI.encode_query(%{state: state}, :rfc3986)
    generate_oauth_url(conn) <> "&#{params}"
  end

  def generate_oauth_url(conn, query) when is_map(query) do
    query = URI.encode_query(query, :rfc3986)
    generate_oauth_url(conn) <> "&#{query}"
  end

  @doc """
  `get_token/2` encodes the secret keys and authorization code returned by Google
  and issues an HTTP request to get a person's profile data.

  **TODO**: we still need to handle the various failure conditions >> issues/16
  """
  @spec get_token(String.t(), conn) :: {:ok, map} | {:error, any}
  def get_token(code, conn) when is_map(conn) do
    redirect_uri = generate_redirect_uri(conn)

    inject_poison().post(@google_token_url, req_body(code, redirect_uri))
    |> parse_body_response()
  end

  @spec get_token(String.t(), url) :: {:ok, map} | {:error, any}
  def get_token(code, url) when is_binary(url) do
    redirect_uri = generate_redirect_uri(url)

    inject_poison().post(@google_token_url, req_body(code, redirect_uri))
    |> parse_body_response()
  end

  defp req_body(code, redirect_uri) do
    Jason.encode!(%{
      client_id: google_client_id(),
      client_secret: google_client_secret(),
      redirect_uri: redirect_uri,
      grant_type: "authorization_code",
      code: code
    })
  end

  @doc """
  `get_user_profile/1` requests the Google User's userinfo profile data
  providing the access_token received in the `get_token/1` above.
  invokes `parse_body_response/1` to decode the JSON data.

  **TODO**: we still need to handle the various failure conditions >> issues/16
  At this point the types of errors we expect are HTTP 40x/50x responses.
  """
  @spec get_user_profile(String.t()) :: {:ok, map} | {:error, any}
  def get_user_profile(token) do
    params = URI.encode_query(%{access_token: token}, :rfc3986)

    "#{@google_user_profile}?#{params}"
    |> inject_poison().get()
    |> parse_body_response()
  end

  @doc """
  `parse_body_response/1` parses the response returned by Google
  so your app can use the resulting JSON.
  """
  @spec parse_body_response({atom, String.t()} | {:error, any}) :: {:ok, map} | {:error, any}
  def parse_body_response({:error, err}), do: {:error, err}

  def parse_body_response({:ok, response}) do
    body = Map.get(response, :body)
    # make keys of map atoms for easier access in templates
    if body == nil do
      {:error, :no_body}
    else
      {:ok, str_key_map} = Jason.decode(body)
      atom_key_map = for {key, val} <- str_key_map, into: %{}, do: {String.to_atom(key), val}
      {:ok, atom_key_map}
    end

    # https://stackoverflow.com/questions/31990134
  end

  def google_client_id do
    System.get_env("GOOGLE_CLIENT_ID") || Application.get_env(:elixir_auth_google, :client_id)
  end

  defp google_client_secret do
    System.get_env("GOOGLE_CLIENT_SECRET") ||
      Application.get_env(:elixir_auth_google, :client_secret)
  end

  defp google_scope do
    System.get_env("GOOGLE_SCOPE") || Application.get_env(:elixir_auth_google, :google_scope) ||
      @default_scope
  end

  defp get_app_callback_url do
    System.get_env("GOOGLE_CALLBACK_PATH") ||
      Application.get_env(:elixir_auth_google, :callback_path) || @default_callback_path
  end
end
