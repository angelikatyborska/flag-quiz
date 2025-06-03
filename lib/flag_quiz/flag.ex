defmodule FlagQuiz.Flag do
  @callback name() :: String.t()
  @callback code() :: String.t()
  @callback versions() :: [FlagQuiz.Flag.Version]

  # TODO: validate that versions don't include duplicates?
end
