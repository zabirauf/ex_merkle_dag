defmodule MerkleDag.Mixfile do
  use Mix.Project

  def project do
    [app: :merkle_dag,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
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
    [
      {:multihash, github: "zabirauf/ex_multihash"},
      {:uuid, "~> 1.0"},
      {:dialyxir, github: "jeremyjh/dialyxir"},
      {:base58check, github: "gjaldon/base58check"},
      {:exprotobuf, "~> 0.8.5"},
      {:gpb, github: "tomas-abrahamsson/gpb", tag: "3.17.2"},
      {:inch_ex, only: :docs}
    ]
  end
end
