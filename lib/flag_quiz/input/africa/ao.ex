defmodule FlagQuiz.Input.AO do
  @behaviour FlagQuiz.Flag
  alias FlagQuiz.Flag.Modification

  def name, do: "Angola"
  def code, do: "ao"

  @hide_star %{
    type: :hide,
    params: %{
      objects: ["main-symbol-star"]
    }
  }

  @make_main_symbol_white %{
    type: :change_fill,
    params: %{
      value: "#FFFFFF",
      objects: ["main-symbol"]
    }
  }

  @flip_main_symbol %{
    type: :flip,
    params: %{
      plane: :horizontal,
      objects: ["main-symbol"]
    }
  }

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
      %Modification{id: :flip_main_symbol, tweaks: [@flip_main_symbol]},
      %Modification{id: :hide_star, tweaks: [@hide_star]},
      %Modification{id: :make_main_symbol_white, tweaks: [@make_main_symbol_white]},
      %Modification{id: :tricolor_swap_1_and_2, tweaks: [@swap_stripes_1_and_2]},
      %Modification{id: :stretch_x_flag, tweaks: [@stretch_x_flag]},
      %Modification{id: :shrink_x_flag, tweaks: [@shrink_x_flag]}
    ]
  end
end
