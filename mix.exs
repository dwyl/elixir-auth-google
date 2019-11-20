defmodule ElixirAuthGoogle.MixProject do
  use Mix.Project

  @description "Minimalist Google OAuth Authentication for Elixir Apps"
  @version "0.1.0"

  def project do
    [
      app: :elixir_auth_google,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: @description,
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.6"},
      {:poison, "~> 4.0"}
    ]
  end

  defp package do
    [
      maintainers: ["dwyl"],
      licenses: ["GNU GPL v2.0"],
      links: %{github: "https://github.com/dwyl/elixir-auth-google"},
      files: ~w(lib LICENSE mix.exs README.md .formatter.exs)
    ]
  end
end
