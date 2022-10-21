# lib/app_web/controllers/one_tap_controller.ex

defmodule AppWeb.OneTapController do
  @moduledoc """
  Callback to Google's answer
  """
  use Phoenix.Controller

  def handle(conn, %{"credential" => jwt}) do
    {:ok, profile} = App.GoogleCerts.verified_identity(jwt)

    conn
    |> Plug.Conn.fetch_session()
    |> Plug.Conn.put_session(:profile, profile)
    |> redirect(to: "/welcome")
    |> Plug.Conn.halt()
  end
end
