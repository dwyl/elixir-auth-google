defmodule AppWeb.OneTapController do
  # use Phoenix.Controller

  @iss "https://accounts.google.com"
  @g_app_id System.get_env("GOOGLE_CLIENT_ID")

  def handle(conn, %{"credential" => credential}) do
    {:ok,
     %{
       "aud" => aud,
       "azp" => azp,
       "email" => email,
       "iss" => iss,
       "name" => name,
       "picture" => pic,
       "sub" => sub
     }} = LiveMap.GoogleCerts.verified_identity(credential)

    # one can use JOSE.JWT.peek_payload(credential)

    with true <- check_user(aud, azp),
         true <- check_iss(iss) do
      profile = %{email: email, name: name, google_id: sub, picture: pic}
      user = ElixirAuthOneTap.User.new(email)
      user_token = ElixirAuthOneTap.Token.user_generate(user.id)

      conn
      |> Plug.Conn.fetch_session()
      |> Plug.Conn.put_session(:user_token, user_token)
      |> Plug.Conn.put_session(:user_id, user.id)
      |> Plug.Conn.put_session(:profile, profile)
      |> Phoenix.Controller.redirect(to: "/welcome")
      |> Plug.Conn.halt()
    end
  end

  def check_user(aud, azp) do
    aud == aud() || azp == aud()
  end

  def check_iss(iss), do: iss == @iss
  def aud, do: @g_app_id
end
