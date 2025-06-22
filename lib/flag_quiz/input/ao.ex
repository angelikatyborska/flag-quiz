defmodule FlagQuiz.Input.AO do
  @behaviour FlagQuiz.Flag
  alias FlagQuiz.Flag.Modification

  def name, do: "Angola"
  def code, do: "ao"

  @swap_stripes_1_and_2 %{
    type: :swap_fill,
    params: %{
      objects1: ["stripe1"],
      objects2: ["stripe2"]
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

  def modification_conflicts do
    [
      {:stretch_x_flag, :shrink_x_flag}
    ]
  end

  def modifications do
    [
      %Modification{id: :tricolor_swap_1_and_2, tweaks: [@swap_stripes_1_and_2]},
      %Modification{id: :stretch_x_flag, tweaks: [@stretch_x_flag]},
      %Modification{id: :shrink_x_flag, tweaks: [@shrink_x_flag]}
    ]
  end
end
