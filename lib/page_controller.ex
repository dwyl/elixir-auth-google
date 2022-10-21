defmodule AppWeb.PageController do
  # use Phoenix.Controller

  def index(conn, _p) do
    Phoenix.Controller.render(conn, "index.html")
  end
end
