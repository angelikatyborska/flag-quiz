defmodule FlagQuiz.Data.GA do
  @behaviour FlagQuiz.Flag
  alias FlagQuiz.Flag.Version

  def name, do: "Gabon"
  def code, do: "ga"

  @swap_stripes_1_and_2 %{
    type: :swap_fill,
    params: %{
      objects1: ["stripe1"],
      objects2: ["stripe2"]
    }
  }

  @swap_stripes_1_and_3 %{
    type: :swap_fill,
    params: %{
      objects1: ["stripe1"],
      objects2: ["stripe3"]
    }
  }

  @swap_stripes_2_and_3 %{
    type: :swap_fill,
    params: %{
      objects1: ["stripe2"],
      objects2: ["stripe3"]
    }
  }

  def versions do
    [
      %Version{modifications: [@swap_stripes_1_and_2]},
      %Version{modifications: [@swap_stripes_1_and_3]},
      %Version{modifications: [@swap_stripes_2_and_3]}
    ]
  end
end
