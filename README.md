# elixir-auth-google
Google OAuth Authentication for Elixir Apps

# How to use elixir_auth_google

- Add the hex package to your project's dependencies:
```elixir
def deps do
  [
    {:elixir_auth_google, "~> 0.1.0"}
  ]
end
```

- Create a Google application and add the `client_id` of the application
  to your appication configuration, for example in `config.exs`:
```elixir
config :elixir_auth_google,
  client_id: <YOUR-CLIENT-ID-HERE>,
```