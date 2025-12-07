defmodule FlagQuiz.Flag.Version do
  defstruct [:modifications]

  @type t :: %__MODULE__{
          modifications: [FlagQuiz.Flag.Modification.t()]
        }
end
