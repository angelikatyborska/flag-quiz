defmodule FlagQuiz.Input.CL do
  @behaviour FlagQuiz.Flag
  alias FlagQuiz.Flag.Modification

  def name, do: "Chile"
  def code, do: "cl"

  @make_main_symbol_red %{
    type: :change_fill,
    params: %{
      value: "#DA291C",
      objects: ["main-symbol"]
    }
  }

  @make_main_symbol_blue %{
    type: :change_fill,
    params: %{
      value: "#0032A0",
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

  @swap_stripe_1_and_half_stripe %{
    type: :swap_fill,
    params: %{
      objects1: ["stripe1"],
      objects2: ["half-stripe1", "half-stripe1-second-half"]
    }
  }
  @swap_stripe_2_and_half_stripe %{
    type: :swap_fill,
    params: %{
      objects1: ["stripe2"],
      objects2: ["half-stripe1", "half-stripe1-second-half"]
    }
  }

  @stretch_x_flag %{
    type: :scale_x_flag,
    params: %{
      background_objects: ["stripes"],
      value: 1.33
    }
  }

  @stretch_x_flag_symbol_translate %{
    type: :translate,
    params: %{
      objects: ["main-symbol"],
      x: "-75%",
      y: "0"
    }
  }
  @stretch_x_flag_symbol_zoom %{
    type: :zoom,
    params: %{
      objects: ["main-symbol"],
      value: "1.33"
    }
  }

  @shrink_x_flag %{
    type: :scale_x_flag,
    params: %{
      background_objects: ["stripes"],
      value: 0.75
    }
  }

  @shrink_x_flag_symbol_translate %{
    type: :translate,
    params: %{
      objects: ["main-symbol"],
      x: "50%",
      y: "0"
    }
  }

  @more_texas_stretch_half_stripe %{
    type: :reveal,
    params: %{
      objects: ["half-stripe1-second-half"]
    }
  }

  @more_texas_move_star %{
    type: :translate,
    params: %{
      objects: ["main-symbol-wrapper"],
      x: "0",
      y: "150px"
    }
  }

  def modification_conflicts do
    [
      {:stretch_x_flag, :shrink_x_flag},
      {:tricolor_swap_1_and_2, :tricolor_swap_1_and_3},
      {:tricolor_swap_1_and_2, :tricolor_swap_1_and_3_alt},
      {:tricolor_swap_1_and_2, :tricolor_swap_2_and_3},
      {:tricolor_swap_1_and_3, :tricolor_swap_2_and_3},
      {:tricolor_swap_1_and_3_alt, :tricolor_swap_2_and_3},
      {:tricolor_swap_1_and_3, :tricolor_swap_1_and_3_alt}
    ]
  end

  def modifications do
    [
      %Modification{id: :tricolor_swap_1_and_2, tweaks: [@swap_stripes_1_and_2]},
      %Modification{
        id: :tricolor_swap_1_and_3,
        tweaks: [@swap_stripe_1_and_half_stripe, @make_main_symbol_red]
      },
      %Modification{
        id: :tricolor_swap_1_and_3_alt,
        tweaks: [@swap_stripe_1_and_half_stripe, @make_main_symbol_blue]
      },
      %Modification{id: :tricolor_swap_2_and_3, tweaks: [@swap_stripe_2_and_half_stripe]},
      %Modification{
        id: :stretch_x_flag,
        tweaks: [@stretch_x_flag, @stretch_x_flag_symbol_translate, @stretch_x_flag_symbol_zoom]
      },
      %Modification{
        id: :shrink_x_flag,
        tweaks: [@shrink_x_flag, @shrink_x_flag_symbol_translate]
      },
      %Modification{
        id: :more_texas,
        tweaks: [@more_texas_stretch_half_stripe, @more_texas_move_star]
      }
    ]
  end
end
