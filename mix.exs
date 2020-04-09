defmodule Server.MixProject do
  use Mix.Project

  def project do
    [
      app: :server,
      description: "Validatex example",
      dialyzer: dialyzer_base(),
      version: "0.1.0",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Server.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      validatex_dep(Mix.env(), "1.0.1"),
      {:phoenix_live_view, "~> 0.11.1"},
      {:phoenix, "~> 1.4.16"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:result, "~> 1.5.0"},
      {:ex_maybe, "~> 1.1.1"},
      {:credo, "~> 1.3.2", only: [:dev, :test]},
      {:excoveralls, "~> 0.12.1", only: [:dev, :test]},
      {:dialyxir, "~> 1.0.0", only: [:dev], runtime: false}
    ]
  end

  defp package do
    [
      maintainers: [
        "Jindrich K. Smitka <smitka.j@gmail.com>",
        "Ondrej Tucek <ondrej.tucek@gmail.com>"
      ],
      licenses: ["Private"],
      links: %{
        "GitHub" => "https://github.com/iodevs/validatex_example"
      }
    ]
  end

  defp validatex_dep(:dev, _tag) do
    {:validatex, path: "../validatex", override: true}
  end

  defp validatex_dep(_, tag) do
    {:validatex, "~> #{tag}"}
  end

  defp dialyzer_base() do
    [
      plt_add_deps: :transitive,
      ignore_warnings: "dialyzer.ignore-warnings",
      flags: [
        :unmatched_returns,
        :error_handling,
        :race_conditions,
        :no_opaque
      ]
    ]
  end
end
