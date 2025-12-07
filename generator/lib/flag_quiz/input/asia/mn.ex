defmodule FlagQuiz.Input.MN do
  @behaviour FlagQuiz.Flag
  alias FlagQuiz.Flag.Modification

  def name, do: "Mongolia"
  def code, do: "mn"

  @flip_horizontal_flag %{
    type: :flip,
    params: %{
      objects: ["flag"],
      plane: :horizontal
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
      x: "45%",
      y: "0"
    }
  }

  @shrink_x_flag_symbol_shrink %{
    type: :zoom,
    params: %{
      objects: ["main-symbol"],
      value: "0.8"
    }
  }

  @swap_red_and_blue %{
    type: :swap_fill,
    params: %{
      objects1: ["blue-stripe"],
      objects2: ["red-background1", "red-background2", "red-background3"]
    }
  }

  @zoom_blue %{
    type: :zoom,
    params: %{
      objects: ["blue-stripe"],
      value: 1.45
    }
  }

  @zoom_blue_symbol_translate %{
    type: :translate,
    params: %{
      objects: ["main-symbol"],
      x: "-20%",
      y: "0"
    }
  }

  @hide_blue %{
    type: :hide,
    params: %{
      objects: ["blue-stripe"]
    }
  }

  # TODO: maybe make those conflicts global for all flags?
  def modification_conflicts do
    [
      {:stretch_x_flag, :shrink_x_flag},
      {:hide_blue, :zoom_blue}
    ]
  end

  def modifications do
    [
      %Modification{
        id: :shrink_x_flag,
        tweaks: [@shrink_x_flag, @shrink_x_flag_symbol_translate, @shrink_x_flag_symbol_shrink]
      },
      %Modification{id: :flip_horizontal_flag, tweaks: [@flip_horizontal_flag]},
      %Modification{id: :swap_red_and_blue, tweaks: [@swap_red_and_blue]},
      %Modification{id: :zoom_blue, tweaks: [@zoom_blue, @zoom_blue_symbol_translate]},
      %Modification{id: :hide_blue, tweaks: [@hide_blue]}
    ]
  end
end
