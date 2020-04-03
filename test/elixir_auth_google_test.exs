defmodule ElixirAuthGoogleTest do
  use ExUnit.Case, async: true
  # use Plug.Test
  doctest ElixirAuthGoogle


  test "get_baseurl_from_conn(conn) detects the URL based on conn.host" do
    conn = %{
      host: "localhost",
      port: 4000
    }
    assert ElixirAuthGoogle.get_baseurl_from_conn(conn) == "http://localhost:4000"
  end


  test "get_baseurl_from_conn(conn) detects the URL for production" do
    conn = %{
      host: "dwyl.com",
      port: 80
    }
    assert ElixirAuthGoogle.get_baseurl_from_conn(conn) == "https://dwyl.com"
  end

  test "get Google login url" do
    conn = %{
      host: "localhost",
      port: 4000
    }
    assert ElixirAuthGoogle.generate_oauth_url(conn) =~ "https://accounts.google.com/o/oauth2/v2/auth?response_type=code"
  end

  test "get Google login url with state" do
    conn = %{
      host: "localhost",
      port: 4000
    }
    url = ElixirAuthGoogle.generate_oauth_url(conn, "state1")
    id = System.get_env("GOOGLE_CLIENT_ID")
    expected = "https://accounts.google.com/o/oauth2/v2/auth?response_type=code&client_id=" <> id
      <> "&scope=profile email&redirect_uri=http://localhost:4000/auth/google/callback&state=state1"
    assert url == expected
  end

  test "get Google token" do
        conn = %{
      host: "localhost",
      port: 4000
    }
    {:ok, res} = ElixirAuthGoogle.get_token("ok_code", conn)
    assert res == %{access_token: "token1"}
  end

  test "get_user_profile/1" do
    res = %{
      email: "nelson@gmail.com",
      email_verified: true,
      family_name: "Correia",
      given_name: "Nelson",
      locale: "en",
      name: "Nelson Correia",
      picture: "https://lh3.googleusercontent.com/a-/AAuE7mApnYb260YC1JY7a",
      sub: "940732358705212133793"
    }
    assert ElixirAuthGoogle.get_user_profile("123") == {:ok, res}
  end

  test "return error with incorrect token" do
    assert ElixirAuthGoogle.get_user_profile("wrong_token") == {:error, :bad_request }
  end
end
