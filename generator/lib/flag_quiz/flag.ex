defmodule FlagQuiz.Flag do
  @callback name() :: String.t()
  @callback code() :: String.t()
  @callback modification_conflicts() :: [
              {FlagQuiz.Flag.Modification.id(), FlagQuiz.Flag.Modification.id()}
            ]
  @callback modifications() :: [FlagQuiz.Flag.Modification.t()]

  # TODO: validate that versions don't include duplicates?
end
