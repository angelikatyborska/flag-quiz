defmodule FlagQuiz.Input.GA do
  @behaviour FlagQuiz.Flag
  alias FlagQuiz.Flag.Modification

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

  # TODO: maybe make those conflicts global for all flags?
  def modification_conflicts do
    [
      {:tricolor_swap_1_and_2, :tricolor_swap_1_and_3},
      {:tricolor_swap_2_and_3, :tricolor_swap_1_and_3},
      {:tricolor_swap_1_and_2, :tricolor_swap_2_and_3}
    ]
  end

  def modifications do
    [
      %Modification{id: :tricolor_swap_1_and_2, tweaks: [@swap_stripes_1_and_2]},
      %Modification{id: :tricolor_swap_1_and_3, tweaks: [@swap_stripes_1_and_3]},
      %Modification{id: :tricolor_swap_2_and_3, tweaks: [@swap_stripes_2_and_3]}
    ]
  end
end
