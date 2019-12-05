defmodule ElixirAuthGoogle.HTTPoison.InMemory do
  @moduledoc """
  In-memory storage for data while it's being processed.
  Because we are mocking the api requests in ElixirAuthGithub.HTTPoison.InMemory
  we have a separate module to delegate the functions we use to the actual
  HTTPoison module, so that's all we do here.
  Note: if you have a suggestion of a better way to do this, please share!
  """

  @doc """
  get/1 passing in the wrong_token is used to test failure in the auth process.
  Obviously, don't invoke it from your App unless you want people to see fails.
  """
  def get("https://www.googleapis.com/oauth2/v3/userinfo?access_token=wrong_token") do
    {:error, :bad_request}
  end

  @doc """
  get/1 using a dummy _url to test body decoding.
  """
  def get(_url), do: {:ok, %{body: Poison.encode!(%{name: "dwyl"})}}

  @doc """
  post/2 passing in dummy _url & _body to test return of access_token.
  """
  def post(_url, _body), do: {:ok, %{body: Poison.encode!(%{access_token: "token1"})}}
end
