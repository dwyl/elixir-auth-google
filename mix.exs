defmodule ElixirAuthGoogle.MixProject do
  use Mix.Project

  @description "Minimalist Google OAuth Authentication for Elixir Apps"
  @version "1.6.10"

  def project do
    [
      app: :elixir_auth_google,
      version: @version,
      elixir: ">= 1.11.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: @description,
      package: package(),
      aliases: aliases(),
      # coverage
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        c: :test,
        coveralls: :test,
        "coveralls.json": :test,
        "coveralls.html": :test,
        t: :test
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
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:httpoison, "~> 2.2.0"},
      {:jason, "~> 1.2"},

      # Track test coverage: github.com/parroty/excoveralls
      {:excoveralls, "~> 0.18.0", only: [:test, :dev]},

      # Mock stuffs in test: github.com/jjh42/mock
      {:mock, "~> 0.3.0", only: :test},

      # documentation
      {:ex_doc, "~> 0.38.2", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["dwyl"],
      licenses: ["GPL-2.0-or-later"],
      links: %{github: "https://github.com/dwyl/elixir-auth-google"},
      files: ~w(lib LICENSE mix.exs README.md .formatter.exs)
    ]
  end

  defp aliases do
    [
      t: ["test"],
      c: ["coveralls.html"]
    ]
  end
end
