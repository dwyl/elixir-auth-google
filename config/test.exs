use Mix.Config

config :elixir_auth_google,
  client_id: "631770888008-6n0oruvsm16kbkqg6u76p5cv5kfkcekt.apps.googleusercontent.com",
  client_secret: "MHxv6-RGF5nheXnxh1b0LNDq",
  httpoison_mock: true

System.put_env(
  "GOOGLE_CLIENT_ID",
  "631770888008-6n0oruvsm16kbkqg6u76p5cv5kfkcekt.apps.googleusercontent.com"
)
