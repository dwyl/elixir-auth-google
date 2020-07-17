defmodule ElixirAuthGoogle.MixProject do
  use Mix.Project

  @description "Minimalist Google OAuth Authentication for Elixir Apps"
  @version "1.3.0"

  def project do
    [
      app: :elixir_auth_google,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: @description,
      package: package(),

      # coverage
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.json": :test,
        "coveralls.html": :test
      ]
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
      {:httpoison, "~> 1.7.0"},
      {:poison, "~> 4.0.1"},

      # tracking test coverage
      {:excoveralls, "~> 0.13.0", only: [:test, :dev]},

      # documentation
      {:ex_doc, "~> 0.21.3", only: :dev}
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
