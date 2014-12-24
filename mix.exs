defmodule Exgenius.Mixfile do
  use Mix.Project

  @description """
    Elixir library for the (undocumented) Rap Genius (and also Rock, Tech, Pop, Country, etc) API
  """

  def project do
    [app: :exgenius,
     version: "0.0.4",
     elixir: "~> 1.0",
     name: "ExGenius",
     description: @description,
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :httpoison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:httpoison, "~> 0.5" },
     {:exjsx, "~> 3.1" }
    ]
  end

  defp package do
    [ contributors: ["Jeff Weiss"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/jeffweiss/exgenius"} ]
  end
end
