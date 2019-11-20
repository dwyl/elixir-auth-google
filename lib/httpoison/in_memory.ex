defmodule ElixirAuthGoogle.HTTPoison.InMemory do
  def get("https://www.googleapis.com/oauth2/v3/userinfo?access_token=wrong_token") do
    {:error, :bad_request}
  end

  def get(_url), do: {:ok, %{body: Poison.encode!(%{name: "dwyl"})}}

  def post(_url, _body), do: {:ok, %{body: Poison.encode!(%{access_token: "token1"})}}
end
