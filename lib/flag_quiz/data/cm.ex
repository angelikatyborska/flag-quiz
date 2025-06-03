defmodule FlagQuiz.Data.Cm do
  @behaviour FlagQuiz.Flag
  alias FlagQuiz.Flag.Version

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

  def versions do
    [
      %Version{modifications: [@zoom_in_star]},
      %Version{modifications: [@zoom_out_star]},
      %Version{modifications: [@swap_stripes_1_and_3]},
      %Version{modifications: [@zoom_in_star, @swap_stripes_1_and_3]},
      %Version{modifications: [@zoom_out_star, @swap_stripes_1_and_3]},
      %Version{modifications: [@black_star]},
      %Version{modifications: [@zoom_in_star, @black_star]},
      %Version{modifications: [@zoom_out_star, @black_star]},
      %Version{modifications: [@swap_stripes_1_and_3, @black_star]},
      %Version{modifications: [@zoom_in_star, @swap_stripes_1_and_3, @black_star]},
      %Version{modifications: [@zoom_out_star, @swap_stripes_1_and_3, @black_star]}
    ]
  end
end
