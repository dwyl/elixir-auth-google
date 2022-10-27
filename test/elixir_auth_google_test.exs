defmodule ElixirAuthGoogleTest do
  use ExUnit.Case, async: true
  # use Plug.Test
  doctest ElixirAuthGoogle

  import Mock

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

    assert ElixirAuthGoogle.generate_oauth_url(conn) =~
             "https://accounts.google.com/o/oauth2/v2/auth?response_type=code"
  end

  test "get Google login url (config redirect uri)" do
    conn = %{
      host: "localhost",
      port: 4000
    }

    url = ElixirAuthGoogle.generate_oauth_url(conn)
    assert url =~ "https://accounts.google.com/o/oauth2/v2/auth?response_type=code"
    assert url =~ "http%3A%2F%2Flocalhost%3A4000"
  end

  # test "get Google login url with state" do
  #   conn = %{
  #     host: "localhost",
  #     port: 4000
  #   }

  #   url = ElixirAuthGoogle.generate_oauth_url(conn, "state1")
  #   id = System.get_env("GOOGLE_CLIENT_ID")
  #   id_from_config = Application.get_env(:elixir_auth_google, :client_id)

  #   assert id == id_from_config

  #   expected =
  #     "https://accounts.google.com/o/oauth2/v2/auth?response_type=code&client_id=" <>
  #       id <>
  #       "&redirect_uri=http%3A%2F%2Flocalhost%3A4000%2Fauth%2Fgoogle%2Fcallback&scope=profile%20email&state=state1"

  #   assert url == expected
  # end

  # test "get Google token" do
  #   conn = %{
  #     host: "localhost",
  #     port: 4000
  #   }

  #   {:ok, res} = ElixirAuthGoogle.get_token("ok_code", conn)
  #   assert res == %{access_token: "token1"}
  # end

  # test "get Google token (config redirect uri)" do
  #   conn = %{
  #     host: "localhost",
  #     port: 4000
  #   }

  #   {:ok, res} = ElixirAuthGoogle.get_token("ok_code", conn)
  #   assert res == %{access_token: "token1"}
  # end

  test "get_profile/1" do
    conn = %{
      host: "localhost",
      port: 4000
    }

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

    assert ElixirAuthGoogle.get_profile("123", conn) == {:ok, res}

    # useless tests for the 100% coveralls
    # assert ElixirAuthGoogle.get_user_profile("123") == {:ok, res}
    # assert ElixirAuthGoogle.parse_response({:ok, %{access_token: "token1"}}) == {:ok, res}
    # assert ElixirAuthGoogle.parse_status({:ok, nil}) == {:error, :bad_request}

    # assert ElixirAuthGoogle.parse_status(
    #          {:ok, %{body: "{\"access_token\":\"token1\"}", status_code: 200}}
    #        ) == {:ok, %{access_token: "token1"}}
  end

  #  useless for coveralls
  # test "utilities" do
  #   assert ElixirAuthGoogle.encode("123") == "access_token=123"
  #   assert ElixirAuthGoogle.convert(%{"a" => 1}) == %{a: 1}
  # end

  test "return error with incorrect token" do
    conn = %{
      host: "localhost",
      port: 4000
    }

    assert ElixirAuthGoogle.get_profile("wrong_token", conn) == {:error, :wrong_code}
  end

  test "get_user_profile return error with incorrect token for the Mock tests" do
    assert ElixirAuthGoogle.get_user_profile("wrong_token") == {:error, :wrong_code}
  end

  test "generate_redirect_uri(conn) generate correct callback url" do
    conn = %{
      host: "foobar.com",
      port: 80
    }

    assert ElixirAuthGoogle.generate_redirect_uri(conn) ==
             "https://foobar.com/auth/google/callback"
  end

  test "generate_redirect_uri(conn) generate correct callback url with custom url path from application environment variable" do
    conn = %{
      host: "foobar.com",
      port: 80
    }

    mock_get_env = fn :elixir_auth_google, :callback_path -> "/special/callback" end

    with_mock Application, get_env: mock_get_env do
      assert ElixirAuthGoogle.generate_redirect_uri(conn) ==
               "https://foobar.com/special/callback"
    end
  end

  test "generate_redirect_uri(conn) generate correct callback url with custom url path from system environment variable" do
    conn = %{
      host: "foobar.com",
      port: 80
    }

    mock_get_env = fn "GOOGLE_CALLBACK_PATH" -> "/very/special/callback" end

    with_mock System, get_env: mock_get_env do
      assert ElixirAuthGoogle.generate_redirect_uri(conn) ==
               "https://foobar.com/very/special/callback"
    end
  end
end
