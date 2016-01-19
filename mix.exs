defmodule DJTCPReceiver.Mixfile do
  use Mix.Project

  def project do
    [app: :dj,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger,:httpoison,:quantum, :quantum,:extwitter],
    mod: {DJ, []},
    registered: [DJ.DJFile]

    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.8.0"},
      {:json,    "~> 0.3.0"},
      {:quantum, "~> 1.6.1"},
      {:oauth, github: "tim/erlang-oauth"},
      {:extwitter, "~> 0.6"},
      {:exrm, "~> 0.18.1"}
    ]
  end
end
