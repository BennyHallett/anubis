defmodule Anubis.Mixfile do
  use Mix.Project

  @version "0.3.1"

  def project do
    [app: :anubis,
     version: @version,
     elixir: "~> 1.5",
     package: package(),
     docs: [readme: true, main: "README.md"],
     description: """
      Anubis is a framework for building command line applications.
     """,
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      # Docs
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:earmark, ">= 1.2.3", only: :dev, runtime: false},
    ]
  end

  defp package do
    %{
      licenses: ["MIT"],
      contributors: ["Benny Hallett", "Bernat Jufré"],
      links: %{ "Github" => "https://github.com/bennyhallet/anubis" }
    }
  end
end
