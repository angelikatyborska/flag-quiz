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

  @black_star %{
    type: :change_fill,
    params: %{
      objects: ["star"],
      value: "#000000"
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
      {:tricolor_swap_1_and_2, :tricolor_swap_1_and_3},
      {:zoom_in_central_symbol, :zoom_out_central_symbol},
      {:stretch_x_flag, :shrink_x_flag}
    ]
  end

  def modifications do
    [
      %Modification{id: :zoom_in_central_symbol, tweaks: [@zoom_in_star]},
      %Modification{id: :zoom_out_central_symbol, tweaks: [@zoom_out_star]},
      %Modification{id: :tricolor_swap_1_and_2, tweaks: [@swap_stripes_1_and_2]},
      %Modification{id: :tricolor_swap_1_and_3, tweaks: [@swap_stripes_1_and_3]},
      %Modification{id: :make_star_black, tweaks: [@black_star]},
      %Modification{id: :stretch_x_flag, tweaks: [@stretch_x_flag]},
      %Modification{id: :shrink_x_flag, tweaks: [@shrink_x_flag]}
    ]
  end
end
