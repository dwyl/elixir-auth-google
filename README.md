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

- Create a Google application and add create the environment variable `GOOGLE_CLIENT_ID`
containing the client id of the application just created. `elixir-auth-google` package will
load this value automatically but will raised an error if it is not defined.