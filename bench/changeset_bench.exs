defmodule ChangesetBench do
  use Benchfella

  @preterit ~w( p r e t e r i t )
  @zeitgeist ~w( z e i t g e i s t )

  @markantony ~w( m a r k a n t o n y )
  @anotherman ~w( a n o t h e r m a n )

  @figurine "figurine"
  @ligature "ligature"

  bench "`preterit` -> `zeitgeist` edit steps" do
    Changeset.edits(@preterit, @zeitgeist)
  end

  bench "`mark antony` -> `another man` edit steps" do
    Changeset.edits(@markantony, @anotherman)
  end

  bench "`preterit` <-> `zeitgeist` levenshtein distance" do
    Changeset.levenshtein(@preterit, @zeitgeist)
  end

  bench "`figurine` <-> `ligature` (as binaries) levenshtein distance" do
    Changeset.levenshtein(@figurine, @ligature)
  end

end
