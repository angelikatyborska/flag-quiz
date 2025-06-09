defmodule FlagQuiz.Data.AU do
  @behaviour FlagQuiz.Flag
  alias FlagQuiz.Flag.Version

  def name, do: "Australia"
  def code, do: "au"

  @hide_big_star %{
    type: :hide,
    params: %{
      objects: ["star-big"]
    }
  }

  @hide_small_star %{
    type: :hide,
    params: %{
      objects: ["star-small"]
    }
  }

  @move_small_star %{
    type: :translate,
    params: %{
      objects: ["star-small"],
      x: "-320%",
      y: "-370%"
    }
  }

  @make_stars_red %{
    type: :change_fill,
    params: %{
      value: "#c8102e",
      objects: ["star-small", "star-big", "star1", "star2", "star3", "star4"]
    }
  }

  @add_stars_stroke %{
    type: :add_stroke,
    params: %{
      color: "#ffffff",
      width: 30,
      objects: ["star-small", "star-big", "star1", "star2", "star3", "star4"]
    }
  }

  def versions do
    [
      %Version{modifications: [@hide_big_star]},
      %Version{modifications: [@hide_small_star]},
      %Version{modifications: [@hide_big_star, @hide_small_star]},
      %Version{modifications: [@make_stars_red, @add_stars_stroke]},
      %Version{modifications: [@hide_big_star, @make_stars_red, @add_stars_stroke]},
      %Version{modifications: [@hide_small_star, @make_stars_red, @add_stars_stroke]},
      %Version{
        modifications: [@hide_big_star, @hide_small_star, @make_stars_red, @add_stars_stroke]
      },
      %Version{
        modifications: [@move_small_star]
      },
      %Version{modifications: [@hide_big_star, @move_small_star]},
      %Version{modifications: [@make_stars_red, @add_stars_stroke, @move_small_star]},
      %Version{
        modifications: [@hide_big_star, @make_stars_red, @add_stars_stroke, @move_small_star]
      },
      %Version{modifications: [@make_stars_red, @add_stars_stroke, @move_small_star]},
      %Version{
        modifications: [@hide_big_star, @make_stars_red, @add_stars_stroke, @move_small_star]
      }
    ]
  end
end
