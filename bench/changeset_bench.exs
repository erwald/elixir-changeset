defmodule ChangesetBench do
  use Benchfella

  @preterit String.split("preterit", "", trim: true)
  @zeitgeist String.split("zeitgeist", "", trim: true)

  bench "preterit <-> zeitgeist difference" do
    Changeset.difference(@preterit, @zeitgeist)
  end

  bench "preterit -> zeitgeist edit steps" do
    Changeset.edit_steps(@preterit, @zeitgeist)
  end

  bench "preterit <-> zeitgeist levenshtein distance" do
    Changeset.levenshtein(@preterit, @zeitgeist)
  end

end
