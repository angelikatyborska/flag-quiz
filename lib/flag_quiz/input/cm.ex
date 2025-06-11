defmodule FlagQuiz.Input.CM do
  @behaviour FlagQuiz.Flag
  alias FlagQuiz.Flag.Modification

  def name, do: "Cameroon"
  def code, do: "cm"

  @zoom_in_star %{
    type: :zoom,
    params: %{
      value: 1.33,
      objects: ["star-wrapper"]
    }
  }

  @zoom_out_star %{
    type: :zoom,
    params: %{
      value: 0.66,
      objects: ["star-wrapper"]
    }
  }

  @swap_stripes_1_and_3 %{
    type: :swap_fill,
    params: %{
      objects1: ["stripe1"],
      objects2: ["stripe3"]
    }
  }

  @black_star %{
    type: :change_fill,
    params: %{
      objects: ["star"],
      value: "#000000"
    }
  }

  def modification_conflicts do
    []
  end

  def modifications do
    [
      %Modification{id: :zoom_in_central_symbol, tweaks: [@zoom_in_star]},
      %Modification{id: :zoom_out_central_symbol, tweaks: [@zoom_out_star]},
      %Modification{id: :tricolor_swap_1_and_3, tweaks: [@swap_stripes_1_and_3]},
      %Modification{id: :make_star_black, tweaks: [@black_star]}
    ]
  end
end
