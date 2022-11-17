defmodule ElixirAuthGoogle.HTTPoisonMock do
  @moduledoc """
  This is a TestDouble for HTTPoison which returns a predictable response.
  Please see: https://github.com/dwyl/elixir-auth-google/issues/35
  """

  @doc """
  get/1 passing in the wrong_token is used to test failure in the auth process.
  Obviously, don't invoke it from your App unless you want people to see fails.
  """
  @wrong_url "https://www.googleapis.com/oauth2/v3/userinfo?access_token=wrong_token"
  def get(@wrong_url) do
    {:ok, %{status_code: 400}}
  end

  @bad_profile "https://www.googleapis.com/oauth2/v3/userinfo?access_token=bad_profile"
  def get(@bad_profile) do
    {:ok, {:error, :bad_request}}
  end

  # get/1 using a dummy _url to test body decoding.
  def get(_url) do
    {:ok,
     %{
       status_code: 200,
       body:
         Jason.encode!(%{
           email: "nelson@gmail.com",
           email_verified: true,
           family_name: "Correia",
           given_name: "Nelson",
           locale: "en",
           name: "Nelson Correia",
           picture: "https://lh3.googleusercontent.com/a-/AAuE7mApnYb260YC1JY7a",
           sub: "940732358705212133793"
         })
     }}
  end

  @doc """
  post/2 passing in dummy _url & _body to test return of access_token.
  """

  def post(_url, body) do
    case Jason.decode!(body) do
      %{"code" => "body_nil"} ->
        {:ok, %{status_code: 200, body: nil}}

      %{"code" => "bad_profile"} ->
        {:ok, %{status_code: 200, body: Jason.encode!(%{access_token: "bad_profile"})}}

      %{"code" => "123"} ->
        {:ok,
         %{
           status_code: 200,
           body: Jason.encode!(%{access_token: "token1"})
         }}

      %{"code" => "wrong_token"} ->
        {:ok, %{status_code: 400}}
    end
  end
end
