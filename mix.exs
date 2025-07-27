defmodule ExFinchTwitch.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_finch_twitch,
      version: "0.0.1-dev",
      elixir: "~> 1.17",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "ExFinchTwitch",
      source_url: "https://github.com/Sudo-Kid/ex_finch_twitch",
      homepage_url: "https://hexdocs.pm/ex_finch_twitch",
      docs: [
        # the module to load by default
        main: "ExFinchTwitch",
        extras: ["README.md", "LICENSE"],
        groups_for_modules: [
          Core: [ExFinchTwitch],
          HTTP: [ExFinchTwitch.Client]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ExFinchTwitch.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:finch, "~> 0.13"},
      {:bypass, "~> 2.1", only: :test},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "EXPERIMENTAL: A wrapper library to make using the Twitch API easier."
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "ex_finch_twitch",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE CHANGELOG.md),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Sudo-Kid/ex_finch_twitch"}
    ]
  end
end
