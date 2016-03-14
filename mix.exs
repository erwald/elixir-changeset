defmodule Changeset.Mixfile do
  use Mix.Project

  def project do
    [app: :changeset,
    name: "Changeset",
    source_url: "https://github.com/erwald/elixir-changeset",
    version: "0.2.1",
    elixir: "~> 1.2",
    description: description,
    package: package,
    build_embedded: Mix.env == :prod,
    start_permanent: Mix.env == :prod,
    deps: deps,
    docs: [extras: ["README.md"]]
  ]
end

# Configuration for the OTP application
#
# Type "mix help compile.app" for more information
def application do
  [applications: []]
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
  [{:earmark, "~> 0.2.1", only: :dev},
  {:ex_doc, "~> 0.11.4", only: :dev},
  {:benchfella, "~> 0.3.2", only: :dev},
  {:credo, "~> 0.3.7", only: :dev},
  {:defmemo, "~> 0.1.1"}]
end

defp description do
  """
  A package for calculating between-list edit distances.
  """
end

defp package do
  [files: ["lib", "mix.exs", "README*", "LICENSE*"],
  maintainers: ["Erich Grunewald"],
  licenses: ["MIT"],
  links: %{"GitHub" => "https://github.com/erwald/elixir-changeset"}
]
end
end
