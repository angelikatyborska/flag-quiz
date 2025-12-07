defmodule FlagQuiz.Input.AU do
  @behaviour FlagQuiz.Flag
  alias FlagQuiz.Flag.Modification

  def name, do: "Australia"
  def code, do: "au"

  @hide_big_star %{
    type: :hide,
    params: %{
      objects: ["star-big"]
    }
  }

  @reveal_big_star_5arm %{
    type: :reveal,
    params: %{
      objects: ["star-big-5arm"]
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
      objects: ["star-small", "star-big", "star-big-5arm", "star1", "star2", "star3", "star4"]
    }
  }

  @add_stars_stroke %{
    type: :add_stroke,
    params: %{
      color: "#ffffff",
      width: 30,
      objects: ["star-small", "star-big", "star-big-5arm", "star1", "star2", "star3", "star4"]
    }
  }

  def modification_conflicts do
    [
      {:hide_small_star, :move_small_star},
      {:hide_big_star, :swap_big_stars}
    ]
  end

  def modifications do
    [
      %Modification{id: :hide_big_star, tweaks: [@hide_big_star]},
      %Modification{id: :hide_small_star, tweaks: [@hide_small_star]},
      %Modification{id: :make_stars_red, tweaks: [@make_stars_red, @add_stars_stroke]},
      %Modification{id: :move_small_star, tweaks: [@move_small_star]},
      %Modification{id: :swap_big_stars, tweaks: [@reveal_big_star_5arm, @hide_big_star]}
    ]
  end
end
