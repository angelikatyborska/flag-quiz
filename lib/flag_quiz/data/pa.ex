defmodule FlagQuiz.Data.PA do
  @behaviour FlagQuiz.Flag
  alias FlagQuiz.Flag.Version

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

  def versions do
    [
      %Version{modifications: [@zoom_in_stars]},
      %Version{modifications: [@zoom_out_stars]},
      %Version{
        modifications: [
          %{
            type: :rotate,
            params: %{
              angle: 36,
              objects: @stars
            }
          }
        ]
      },
      %Version{
        modifications: [
          %{
            type: :rotate,
            params: %{
              angle: 180,
              objects: ["flag"]
            }
          }
        ]
      },
      %Version{
        modifications: [
          %{
            type: :flip,
            params: %{
              plane: "horizontal",
              objects: ["flag"]
            }
          }
        ]
      },
      %Version{
        modifications: [
          %{
            type: :zoom,
            params: %{
              value: 1.2,
              objects: @stars
            }
          },
          %{
            type: :flip,
            params: %{
              plane: "horizontal",
              objects: ["flag"]
            }
          }
        ]
      },
      %Version{
        modifications: [
          @zoom_out_stars,
          %{
            type: :flip,
            params: %{
              plane: "horizontal",
              objects: ["flag"]
            }
          }
        ]
      },
      %Version{
        modifications: [
          %{
            type: :flip,
            params: %{
              plane: "vertical",
              objects: ["flag"]
            }
          }
        ]
      }
    ]
  end
end
