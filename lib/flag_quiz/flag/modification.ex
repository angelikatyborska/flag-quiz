defmodule FlagQuiz.Flag.Modification do
  @type t :: flip | zoom | rotate

  # TODO: setup dialyxir and CI to verify the types are correct
  @type zoom :: %{type: :zoom, params: %{objects: [String.t()], value: number}}
  @type flip :: %{type: :flip, params: %{objects: [String.t()], plane: :horizontal | :vertical}}
  @type rotate :: %{type: :rotate, params: %{objects: [String.t()], value: number}}

  # TODO: figure out how to dry it up?

  @spec apply_modifications(flag :: FlagQuiz.Flag.t(), version :: FlagQuiz.Flag.Version.t()) ::
          FlagQuiz.Svg.t()
  def apply_modifications(flag, version) do
    Enum.reduce(version["modifications"], flag, fn mod, doc ->
      case mod.type do
        :zoom ->
          zoom(doc, mod)

        :flip ->
          flip(doc, mod)

        :rotate ->
          rotate(doc, mod)

        _ ->
          nil
      end
    end)
  end

  def zoom(doc, mod) do
    %{
      params: %{
        value: value,
        objects: objects
      }
    } = mod

    Enum.reduce(objects, doc, fn object, acc ->
      acc
      |> FlagQuiz.Svg.set_attribute_on_element_with_id(
        object,
        :style,
        "transform: scale(#{value}); transform-box: fill-box; transform-origin: center"
      )
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

      acc
      |> FlagQuiz.Svg.set_attribute_on_element_with_id(
        object,
        :style,
        "transform: scale(#{value}); transform-box: fill-box; transform-origin: center"
      )
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
      acc
      |> FlagQuiz.Svg.set_attribute_on_element_with_id(
        object,
        :style,
        "transform: rotate(#{value}deg); transform-box: fill-box; transform-origin: center"
      )
    end)
  end
end
