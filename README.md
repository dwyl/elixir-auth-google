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

- Create a Google application and generate OAuth credentials for the application
  
- Set up `:elixir_auth_google` configuration values 
`google_client_id`, `google_scope` ("profile" by default) and `google_redirect_uri` (the same as the one defined in the google application)

, for example in `config.exs`:
```elixir
config :elixir_auth_google,
  google_client_id: <YOUR-CLIENT-ID-HERE>,
  google_scope: "profile",
  google_redirect_uri: <REDIRECT_URI>,
```