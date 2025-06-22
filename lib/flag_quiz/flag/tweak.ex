defmodule FlagQuiz.Flag.Tweak do
  @type t :: flip | zoom | rotate

  # TODO: setup dialyxir and CI to verify the types are correct
  @type zoom :: %{type: :zoom, params: %{objects: [String.t()], value: number}}
  @type flip :: %{type: :flip, params: %{objects: [String.t()], plane: :horizontal | :vertical}}
  @type rotate :: %{type: :rotate, params: %{objects: [String.t()], value: number}}
  @type translate :: %{
          type: :translate,
          params: %{objects: [String.t()], x: String.t(), y: String.t()}
        }
  @type swap_fill :: %{
          type: :swap_fill,
          params: %{objects1: [String.t()], objects2: [String.t()]}
        }
  @type change_fill :: %{
          type: :change_fill,
          params: %{objects: [String.t()], value: String.t()}
        }
  @type add_stroke :: %{
          type: :add_stroke,
          params: %{objects: [String.t()], color: String.t(), width: number()}
        }
  # TODO add reveal
  @type hide :: %{
          type: :hide,
          params: %{objects: [String.t()]}
        }
  @type scale_x_flag :: %{
          type: :scale_x_flag,
          params: %{background_objects: [String.t()], value: number()}
        }

  # TODO: figure out how to dry it up?

  @spec apply_tweaks(flag :: FlagQuiz.Flag.t(), version :: FlagQuiz.Flag.Modification.t()) ::
          FlagQuiz.Svg.t()
  def apply_tweaks(flag, version) do
    # TODO: try to prevent incompatible tweaks applied to the same element?
    Enum.reduce(version.tweaks, flag, fn mod, doc ->
      case mod.type do
        :zoom ->
          zoom(doc, mod)

        :flip ->
          flip(doc, mod)

        :rotate ->
          rotate(doc, mod)

        :translate ->
          translate(doc, mod)

        :swap_fill ->
          swap_fill(doc, mod)

        :change_fill ->
          change_fill(doc, mod)

        :add_stroke ->
          add_stroke(doc, mod)

        :hide ->
          hide(doc, mod)

        :scale_x_flag ->
          scale_x_flag(doc, mod)

        _ ->
          doc
      end
    end)
  end

  @transform_origin "transform-box: fill-box; transform-origin: center;"

  def zoom(doc, mod) do
    %{
      params: %{
        value: value,
        objects: objects
      }
    } = mod

    Enum.reduce(objects, doc, fn object, acc ->
      set_transform(acc, object, "scale(#{value})")
    end)
  end

  def flip(doc, mod) do
    %{
      params: %{
        plane: plane,
        objects: objects
      }
    } = mod

    Enum.reduce(objects, doc, fn object, acc ->
      value =
        if plane === :horizontal do
          "-1, 1"
        else
          "1, -1"
        end

      set_transform(acc, object, "scale(#{value})")
    end)
  end

  def rotate(doc, mod) do
    %{
      params: %{
        angle: value,
        objects: objects
      }
    } = mod

    Enum.reduce(objects, doc, fn object, acc ->
      set_transform(acc, object, "rotate(#{value}deg)")
    end)
  end

  def translate(doc, mod) do
    %{
      params: %{
        x: x,
        y: y,
        objects: objects
      }
    } = mod

    Enum.reduce(objects, doc, fn object, acc ->
      set_transform(acc, object, "translateX(#{x}) translateY(#{y})")
    end)
  end

  def swap_fill(doc, mod) do
    %{
      params: %{
        objects1: objects1,
        objects2: objects2
      }
    } = mod

    color1 = FlagQuiz.Svg.get_attribute_on_element_with_id(doc, Enum.at(objects1, 0), :fill)
    color2 = FlagQuiz.Svg.get_attribute_on_element_with_id(doc, Enum.at(objects2, 0), :fill)

    doc =
      Enum.reduce(objects2, doc, fn object, acc ->
        acc
        |> FlagQuiz.Svg.set_attribute_on_element_with_id(object, :fill, color1)
      end)

    Enum.reduce(objects1, doc, fn object, acc ->
      acc
      |> FlagQuiz.Svg.set_attribute_on_element_with_id(object, :fill, color2)
    end)
  end

  def change_fill(doc, mod) do
    %{
      params: %{
        objects: objects,
        value: value
      }
    } = mod

    Enum.reduce(objects, doc, fn object, acc ->
      acc
      |> FlagQuiz.Svg.set_attribute_on_element_with_id(object, :fill, value)
    end)
  end

  def add_stroke(doc, mod) do
    %{
      params: %{
        objects: objects,
        color: color,
        width: width
      }
    } = mod

    Enum.reduce(objects, doc, fn object, acc ->
      acc
      |> FlagQuiz.Svg.set_attribute_on_element_with_id(object, :stroke, color)
      |> FlagQuiz.Svg.set_attribute_on_element_with_id(object, :"stroke-width", width)
    end)
  end

  def hide(doc, mod) do
    %{
      params: %{
        objects: objects
      }
    } = mod

    Enum.reduce(objects, doc, fn object, acc ->
      acc
      |> FlagQuiz.Svg.set_attribute_on_element_with_id(object, :style, "display: none")
    end)
  end

  def scale_x_flag(doc, mod) do
    %{
      params: %{
        background_objects: background_objects,
        value: value
      }
    } = mod

    original_width =
      FlagQuiz.Svg.get_attribute_on_root_element(doc, :width)
      |> FlagQuiz.Svg.string_number_to_number()

    height =
      FlagQuiz.Svg.get_attribute_on_root_element(doc, :height)
      |> FlagQuiz.Svg.string_number_to_number()

    original_viewbox = FlagQuiz.Svg.get_attribute_on_root_element(doc, :viewBox)

    new_width = original_width * value

    doc =
      FlagQuiz.Svg.set_attribute_on_root_element(
        doc,
        :width,
        new_width |> FlagQuiz.Svg.number_to_string_number()
      )

    [x1, y1, x2, y2] =
      if original_viewbox do
        String.split(original_viewbox, " ") |> Enum.map(&FlagQuiz.Svg.string_number_to_number/1)
      else
        [0, 0, original_width, height]
      end

    x_diff = (x2 - x1) * (1 - value)

    new_viewbox =
      [x1 + x_diff * 0.5, y1, x2 - x_diff, y2]
      |> Enum.map(&FlagQuiz.Svg.number_to_string_number/1)
      |> Enum.join(" ")

    doc =
      FlagQuiz.Svg.set_attribute_on_root_element(doc, :viewBox, new_viewbox)

    Enum.reduce(background_objects, doc, fn object, acc ->
      set_transform(acc, object, "scale(#{value}, 1)")
    end)
  end

  defp set_transform(svg, id, transform) do
    current_style = FlagQuiz.Svg.get_attribute_on_element_with_id(svg, id, :style)
    current_style = to_string(current_style) || ""

    new_style =
      if String.contains?(current_style, "transform:") do
        String.split(current_style, "; ", trim: true)
        |> Enum.map(fn style ->
          if String.starts_with?(style, "transform:") do
            style <> " #{transform}"
          else
            style
          end
        end)
        |> Enum.join("; ")
      else
        "transform: #{transform}; #{@transform_origin}"
      end

    new_style =
      if String.contains?(new_style, transform) do
        new_style
      else
      end

    FlagQuiz.Svg.set_attribute_on_element_with_id(svg, id, :style, new_style)
  end
end
