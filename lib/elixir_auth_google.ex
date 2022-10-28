defmodule ElixirAuthGoogle do
  @moduledoc """
  Minimalist Google OAuth Authentication for Elixir Apps.
  Extensively tested, documented, maintained and in active use in production.
  It exposes two functions, `generate_oauth_url/2` and `get_profile/1`.
  """
  @google_auth_url "https://accounts.google.com/o/oauth2/v2/auth?response_type=code"
  @google_token_url "https://oauth2.googleapis.com/token"
  @google_user_profile "https://www.googleapis.com/oauth2/v3/userinfo"
  @default_scope "profile email"
  @default_callback_path "/auth/google/callback"

  @httpoison (Application.compile_env(:elixir_auth_google, :httpoison_mock) &&
                ElixirAuthGoogle.HTTPoisonMock) || HTTPoison

  @type conn :: map

  @doc """
  `inject_poison/0` injects a TestDouble of HTTPoison in Test
  so that we don't have duplicate mock in consuming apps.
  see: https://github.com/dwyl/elixir-auth-google/issues/35
  """
  def inject_poison, do: @httpoison

  @doc """
  `get_baseurl_from_conn/1` derives the base URL from the conn struct
  """
  @spec get_baseurl_from_conn(conn) :: String.t()
  def get_baseurl_from_conn(%{host: h, port: p}) when h == "localhost" do
    "http://#{h}:#{p}"
  end

  def get_baseurl_from_conn(%{host: h}) do
    "https://#{h}"
  end

  @doc """
  `generate_redirect_uri/1` generates the Google redirect uri based on conn
  """
  def generate_redirect_uri(conn) do
    get_baseurl_from_conn(conn) <> get_app_callback_url()
  end

  @doc """
  Same as `generate_oauth_url/2` with `state` query parameter
  """

  # def generate_oauth_url(conn, state) when is_binary(state) do
  #   params = URI.encode_query(%{state: state}, :rfc3986)
  #   generate_oauth_url(conn) <> "&#{params}"
  # end

  @doc """
  `generate_oauth_url/1` creates the Google OAuth2 URL with client_id, scope and
  redirect_uri which is the URL Google will redirect to when auth is successful.
  This is the URL you need to use for your "Login with Google" button.
  See step 5 of the instructions.
  """
  def generate_oauth_url(conn) do
    query = %{
      client_id: google_client_id(),
      scope: google_scope(),
      redirect_uri: generate_redirect_uri(conn)
    }

    params = URI.encode_query(query, :rfc3986)
    "#{@google_auth_url}&#{params}"
  end

  @doc """
  `get_token/2` encodes the secret keys and authorization code returned by Google
  and issues an HTTP request to get a person's profile data.

  **TODO**: we still need to handle the various failure conditions >> issues/16
  """
  #  <----- RM
  # @spec get_token(String.t(), conn) :: {:ok, map} | {:error, any}
  # def get_token(code, conn) do
  #   body =
  #     Jason.encode!(%{
  #       client_id: google_client_id(),
  #       client_secret: google_client_secret(),
  #       redirect_uri: generate_redirect_uri(conn),
  #       grant_type: "authorization_code",
  #       code: code
  #     })

  #   inject_poison().post(@google_token_url, body)
  #   |> parse_body_response()
  # end

  # <---- +
  def get_profile(code, conn) do
    Jason.encode!(%{
      client_id: google_client_id(),
      client_secret: google_client_secret(),
      redirect_uri: generate_redirect_uri(conn),
      grant_type: "authorization_code",
      code: code
    })
    |> then(fn body ->
      inject_poison().post(@google_token_url, body)
      |> parse_status()
      |> parse_response()
    end)
  end

  # Note: failure status are 400, 401, 404 depending on which input is corrupted.
  # all tested: client_id, secret, redirect_uri, code, @google_token_url, @google-user_profile, params
  def parse_status({:ok, %{status_code: 200}} = response) do
    parse_body_response(response)
  end

  def parse_status({:ok, _}), do: {:error, :bad_request}
  # or more verbose with error status
  # def parse_status({:ok, status}) do
  #   case status do
  #     %{status_code: 404} -> {:error, :wrong_url}
  #     %{status_code: 401} -> {:error, :unauthorized}
  #     %{status_code: 400} -> {:error, :wrong_code}
  #     _ -> {:error, :unknown_error}
  #   end
  # end

  # def parse_body_response({:error, err}), do: {:error, err}

  def parse_body_response({:ok, %{body: nil}}), do: {:error, :no_body}

  def parse_body_response({:ok, %{body: body}}) do
    {:ok,
     body
     |> Jason.decode!()
     |> convert()}
  end

  def convert(str_key_map) do
    for {key, val} <- str_key_map, into: %{}, do: {String.to_atom(key), val}
  end

  def parse_response({:error, response}), do: {:error, response}
  def parse_response({:ok, response}), do: get_user_profile(response.access_token)

  @doc """
  `get_user_profile/1` requests the Google User's userinfo profile data
  providing the access_token received in the `get_token/1` above.
  invokes `parse_body_response/1` to decode the JSON data.

  **TODO**: we still need to handle the various failure conditions >> issues/16
  At this point the types of errors we expect are HTTP 40x/50x responses.
  """

  # @spec get_user_profile(String.t()) :: {:ok, map} | {:error, any}
  # def get_user_profile(token) do
  #   params = URI.encode_query(%{access_token: token}, :rfc3986)

  #   "#{@google_user_profile}?#{params}"
  #   |> inject_poison().get()
  #   |> parse_body_response()
  # end

  #  <---- CHANGED
  def get_user_profile(access_token) do
    access_token
    |> IO.inspect()
    |> encode()
    |> then(fn params ->
      (@google_user_profile <> "?" <> params)
      |> inject_poison().get()
      |> parse_status()
    end)
  end

  #  <---- +
  def encode(token), do: URI.encode_query(%{access_token: token}, :rfc3986)

  @doc """
  `parse_body_response/1` parses the response returned by Google
  so your app can use the resulting JSON.
  """

  # @spec parse_body_response({atom, String.t()} | {:error, any}) :: {:ok, map} | {:error, any}
  # def parse_body_response({:error, err}), do: {:error, err}

  # def parse_body_response({:ok, response}) do
  #   body = Map.get(response, :body)
  #   # make keys of map atoms for easier access in templates
  #   if body == nil do
  #     {:error, :no_body}
  #   else
  #     {:ok, str_key_map} = Jason.decode(body)
  #     atom_key_map = for {key, val} <- str_key_map, into: %{}, do: {String.to_atom(key), val}
  #     {:ok, atom_key_map}
  #   end

  #   # https://stackoverflow.com/questions/31990134
  # end

  def google_client_id do
    System.get_env("GOOGLE_CLIENT_ID") || Application.get_env(:elixir_auth_google, :client_id)
  end

  def google_client_secret do
    System.get_env("GOOGLE_CLIENT_SECRET") ||
      Application.get_env(:elixir_auth_google, :client_secret)
  end

  def google_scope do
    System.get_env("GOOGLE_SCOPE") || Application.get_env(:elixir_auth_google, :google_scope) ||
      @default_scope
  end

  def get_app_callback_url do
    System.get_env("GOOGLE_CALLBACK_PATH") ||
      Application.get_env(:elixir_auth_google, :callback_path) || @default_callback_path
  end
end
