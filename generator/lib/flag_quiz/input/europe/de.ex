defmodule FlagQuiz.Input.DE do
  @behaviour FlagQuiz.Flag
  alias FlagQuiz.Flag.Modification

  def name, do: "Germany"
  def code, do: "de"

  @gold_to_white %{
    type: :change_fill,
    params: %{
      objects: ["stripe3"],
      value: "#ffffff"
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

  @belgium_zoom %{
    type: :zoom,
    params: %{
      objects: ["stripes"],
      value: 1.67
    }
  }

  @belgium_make_stripes_vertical %{
    type: :rotate,
    params: %{
      objects: ["stripes"],
      angle: 90
    }
  }

  @gdr_reveal %{
    type: :reveal,
    params: %{
      objects: ["gdr-main-symbol"]
    }
  }

  def modification_conflicts do
    [
      {:tricolor_swap_1_and_2, :tricolor_swap_1_and_3},
      {:tricolor_swap_2_and_3, :tricolor_swap_1_and_3},
      {:tricolor_swap_1_and_2, :tricolor_swap_2_and_3},
      {:stretch_x_flag, :shrink_x_flag},
      {:shrink_x_flag, :more_belgium},
      {:stretch_x_flag, :more_belgium},
      {:gold_to_white, :more_gdr}
    ]
  end

  def modifications do
    [
      %Modification{id: :gold_to_white, tweaks: [@gold_to_white]},
      %Modification{id: :tricolor_swap_1_and_2, tweaks: [@swap_stripes_1_and_2]},
      %Modification{id: :tricolor_swap_1_and_3, tweaks: [@swap_stripes_1_and_3]},
      %Modification{id: :tricolor_swap_2_and_3, tweaks: [@swap_stripes_2_and_3]},
      %Modification{id: :stretch_x_flag, tweaks: [@stretch_x_flag]},
      %Modification{id: :shrink_x_flag, tweaks: [@shrink_x_flag]},
      %Modification{id: :more_belgium, tweaks: [@belgium_zoom, @belgium_make_stripes_vertical]},
      %Modification{id: :more_gdr, tweaks: [@gdr_reveal]}
    ]
  end
end
