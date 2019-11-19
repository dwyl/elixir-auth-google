use Mix.Config

# Google credentials
config :elixir_auth_google,
  client_id: System.fetch_env!("GOOGLE_CLIENT_ID")

if Mix.env() == :test do
  # define configuration specific to test environment
  # It can be useful when testing/mocking
  nil
end
