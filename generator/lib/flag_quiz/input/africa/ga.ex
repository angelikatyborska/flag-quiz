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

  @stretch_x_flag %{
    type: :scale_x_flag,
    params: %{
      background_objects: ["stripes"],
      value: 1.33
    }
  }

  @shrink_x_flag %{
    type: :scale_x_flag,
    params: %{
      background_objects: ["stripes"],
      value: 0.75
    }
  }

  # TODO: maybe make those conflicts global for all flags?
  def modification_conflicts do
    [
      {:tricolor_swap_1_and_2, :tricolor_swap_1_and_3},
      {:tricolor_swap_2_and_3, :tricolor_swap_1_and_3},
      {:tricolor_swap_1_and_2, :tricolor_swap_2_and_3},
      {:stretch_x_flag, :shrink_x_flag}
    ]
  end

  def modifications do
    [
      %Modification{id: :tricolor_swap_1_and_2, tweaks: [@swap_stripes_1_and_2]},
      %Modification{id: :tricolor_swap_1_and_3, tweaks: [@swap_stripes_1_and_3]},
      %Modification{id: :tricolor_swap_2_and_3, tweaks: [@swap_stripes_2_and_3]},
      %Modification{id: :stretch_x_flag, tweaks: [@stretch_x_flag]},
      %Modification{id: :shrink_x_flag, tweaks: [@shrink_x_flag]}
    ]
  end
end
