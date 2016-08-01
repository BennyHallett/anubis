defmodule Anubis.Mixfile do
  use Mix.Project

  def project do
    [app: :anubis,
     version: "0.3.0",
     elixir: "~> 1.3.1",
     package: package,
     docs: [readme: true, main: "README.md"],
     description: """
      Anubis is a framework for building command line applications.
     """,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    []
  end

  defp package do
    %{
      licenses: ["MIT"],
      contributors: ["Benny Hallett"],
      links: %{ "Github" => "https://github.com/bennyhallett/anubis" }
    }
  end
end
