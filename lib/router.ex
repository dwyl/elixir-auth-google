use AppWeb, :router

pipeline :api do
  plug(:accepts, ["json"])

  post("/auth/one_tap", AppWeb.OneTapController, :handle)
end
