defmodule App.GoogleCerts do
  @moduledoc """
  Received JWT are checked for their integrity vs Google's public keys JWK.
  Based on the Joken library.
  It exposes one function: verifed_identity
  """
  @g_certs3_url "https://www.googleapis.com/oauth2/v3/certs"
  @iss "https://accounts.google.com"
  @g_app_id System.get_env("GOOGLE_CLIENT_ID")

  @doc """
  We retrieve Google's public certs JWK format
  to check the signature of the received token
  """
  defp check_identity(jwt) do
    with {:ok, %{"kid" => kid, "alg" => alg}} <- Joken.peek_header(jwt) do
      %{"keys" => certs} =
        @g_certs3_url
        |> HTTPoison.get!()
        |> Map.get(:body)
        |> Jason.decode!()

      cert = Enum.find(certs, fn cert -> cert["kid"] == kid end)
      signer = Joken.Signer.create(alg, cert)
      Joken.verify(jwt, signer, [])
    end
  end

  @doc """
  Recommended post-checks and delivery the users credentials
  """
  def verified_identity(jwt) do
    {:ok,
     %{
       "aud" => aud,
       "azp" => azp,
       "email" => email,
       "iss" => iss,
       "name" => name,
       "picture" => pic,
       "sub" => sub
     }} = LiveMap.GoogleCerts.check_identity(jwt)

    with true <- check_user(aud, azp),
         true <- check_iss(iss) do
      {:ok, %{email: email, name: name, google_id: sub, picture: pic}}
    end
  end

  # ---- Google post checking recommendations
  defp check_user(aud, azp) do
    aud == aud() || azp == aud()
  end

  defp check_iss(iss), do: iss == @iss
  defp aud, do: @g_app_id
end
