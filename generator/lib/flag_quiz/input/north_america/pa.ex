defmodule FlagQuiz.Input.PA do
  @behaviour FlagQuiz.Flag
  alias FlagQuiz.Flag.Modification

  def name, do: "Panama"
  def code, do: "pa"

  @stars ["star1", "star2"]
  @zoom_in_stars %{
    type: :zoom,
    params: %{
      value: 1.33,
      objects: @stars
    }
  }

  @zoom_out_stars %{
    type: :zoom,
    params: %{
      value: 0.66,
      objects: @stars
    }
  }

  @rotate_stars %{
    type: :rotate,
    params: %{
      angle: 36,
      objects: @stars
    }
  }

  @make_blue_lighter %{
    type: :change_fill,
    params: %{
      objects: ["star2", "rectangle2"],
      value: "#1188bf"
    }
  }

  @swap_colors_horizontally %{
    type: :swap_fill,
    params: %{
      objects1: ["star1", "rectangle1"],
      objects2: ["star2", "rectangle2"]
    }
  }

  @swap_colors_to_horizontal1 %{
    type: :swap_fill,
    params: %{
      objects1: ["star1", "rectangle2"],
      objects2: ["star2", "rectangle1"]
    }
  }

  @swap_colors_to_horizontal2 %{
    type: :swap_fill,
    params: %{
      objects1: ["star1", "rectangle2"],
      objects2: ["star2", "rectangle1"]
    }
  }

  def modification_conflicts do
    [
      {:zoom_in_central_symbol, :zoom_out_central_symbol},
      {:swap_colors_horizontally, :swap_colors_to_horizontal1},
      {:swap_colors_horizontally, :swap_colors_to_horizontal2},
      {:swap_colors_to_horizontal1, :swap_colors_to_horizontal2},
      {:make_blue_lighter, :swap_colors_to_horizontal1},
      {:make_blue_lighter, :swap_colors_to_horizontal2}
    ]
  end

  def modifications do
    [
      %Modification{id: :make_blue_lighter, tweaks: [@make_blue_lighter]},
      %Modification{id: :zoom_in_central_symbol, tweaks: [@zoom_in_stars]},
      %Modification{id: :zoom_out_central_symbol, tweaks: [@zoom_out_stars]},
      %Modification{id: :rotate_stars, tweaks: [@rotate_stars]},
      %Modification{id: :swap_colors_horizontally, tweaks: [@swap_colors_horizontally]},
      %Modification{id: :swap_colors_to_horizontal1, tweaks: [@swap_colors_to_horizontal1]},
      %Modification{id: :swap_colors_to_horizontal2, tweaks: [@swap_colors_to_horizontal2]}
    ]
  end
end
