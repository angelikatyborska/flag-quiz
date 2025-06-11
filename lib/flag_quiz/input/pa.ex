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

  def modification_conflicts do
    []
  end

  def modifications do
    [
      %Modification{id: :zoom_in_central_symbol, tweaks: [@zoom_in_stars]},
      %Modification{id: :zoom_out_central_symbol, tweaks: [@zoom_out_stars]},
      %Modification{id: :rotate_stars, tweaks: [@rotate_stars]}
    ]
  end
end
