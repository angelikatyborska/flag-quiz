defmodule FlagQuiz.Flag.ModificationTest do
  use ExUnit.Case

  describe "zoom" do
    test "scales out" do
      input = """
      <svg xmlns="http://www.w3.org/2000/svg" width="900" height="600" viewBox="0 0 12 8">
        <g id="obj1"><circle cx="50" cy="50" r="50"/></g>
        <g id="obj2"><circle cx="30" cy="30" r="30"/></g>
        <g id="obj3"><circle cx="10" cy="10" r="10"/></g>
      </svg>
      """

      expected_output = """
      <svg xmlns="http://www.w3.org/2000/svg" width="900" height="600" viewBox="0 0 12 8">
        <g id="obj1" style="transform: scale(0.5); transform-box: fill-box; transform-origin: center"><circle cx="50" cy="50" r="50"/></g>
        <g id="obj2"><circle cx="30" cy="30" r="30"/></g>
        <g id="obj3" style="transform: scale(0.5); transform-box: fill-box; transform-origin: center"><circle cx="10" cy="10" r="10"/></g>
      </svg>
      """

      {:ok, doc} = FlagQuiz.Svg.parse_string(input)

      mod = %{
        params: %{value: 0.5, objects: ["obj1", "obj3"]}
      }

      result = FlagQuiz.Flag.Modification.zoom(doc, mod)

      assert FlagQuiz.Svg.export_string(result) == expected_output
    end
  end

  describe "flip" do
    test "flips horizontally" do
      input = """
      <svg xmlns="http://www.w3.org/2000/svg" width="900" height="600" viewBox="0 0 12 8">
        <g id="obj1"><circle cx="50" cy="50" r="50"/></g>
        <g id="obj2"><circle cx="30" cy="30" r="30"/></g>
        <g id="obj3"><circle cx="10" cy="10" r="10"/></g>
      </svg>
      """

      expected_output = """
      <svg xmlns="http://www.w3.org/2000/svg" width="900" height="600" viewBox="0 0 12 8">
        <g id="obj1" style="transform: scale(-1, 1); transform-box: fill-box; transform-origin: center"><circle cx="50" cy="50" r="50"/></g>
        <g id="obj2" style="transform: scale(-1, 1); transform-box: fill-box; transform-origin: center"><circle cx="30" cy="30" r="30"/></g>
        <g id="obj3"><circle cx="10" cy="10" r="10"/></g>
      </svg>
      """

      {:ok, doc} = FlagQuiz.Svg.parse_string(input)

      mod = %{
        params: %{
          objects: ["obj1", "obj2"],
          plane: :horizontal
        }
      }

      result = FlagQuiz.Flag.Modification.flip(doc, mod)

      assert FlagQuiz.Svg.export_string(result) == expected_output
    end

    test "flips vertically" do
      input = """
      <svg xmlns="http://www.w3.org/2000/svg" width="900" height="600" viewBox="0 0 12 8">
        <g id="obj1"><circle cx="50" cy="50" r="50"/></g>
        <g id="obj2"><circle cx="30" cy="30" r="30"/></g>
        <g id="obj3"><circle cx="10" cy="10" r="10"/></g>
      </svg>
      """

      expected_output = """
      <svg xmlns="http://www.w3.org/2000/svg" width="900" height="600" viewBox="0 0 12 8">
        <g id="obj1" style="transform: scale(1, -1); transform-box: fill-box; transform-origin: center"><circle cx="50" cy="50" r="50"/></g>
        <g id="obj2" style="transform: scale(1, -1); transform-box: fill-box; transform-origin: center"><circle cx="30" cy="30" r="30"/></g>
        <g id="obj3"><circle cx="10" cy="10" r="10"/></g>
      </svg>
      """

      {:ok, doc} = FlagQuiz.Svg.parse_string(input)

      mod = %{
        params: %{
          objects: ["obj1", "obj2"],
          plane: :vertical
        }
      }

      result = FlagQuiz.Flag.Modification.flip(doc, mod)

      assert FlagQuiz.Svg.export_string(result) == expected_output
    end
  end

  describe "rotate" do
    test "rotates elements by a given angle" do
      input = """
      <svg xmlns="http://www.w3.org/2000/svg" width="900" height="600" viewBox="0 0 12 8">
        <g id="obj1"><circle cx="50" cy="50" r="50"/></g>
        <g id="obj2"><circle cx="30" cy="30" r="30"/></g>
        <g id="obj3"><circle cx="10" cy="10" r="10"/></g>
      </svg>
      """

      expected_output = """
      <svg xmlns="http://www.w3.org/2000/svg" width="900" height="600" viewBox="0 0 12 8">
        <g id="obj1" style="transform: rotate(45deg); transform-box: fill-box; transform-origin: center"><circle cx="50" cy="50" r="50"/></g>
        <g id="obj2" style="transform: rotate(45deg); transform-box: fill-box; transform-origin: center"><circle cx="30" cy="30" r="30"/></g>
        <g id="obj3"><circle cx="10" cy="10" r="10"/></g>
      </svg>
      """

      {:ok, doc} = FlagQuiz.Svg.parse_string(input)

      mod = %{
        params: %{
          objects: ["obj1", "obj2"],
          angle: 45
        }
      }

      result = FlagQuiz.Flag.Modification.rotate(doc, mod)

      assert FlagQuiz.Svg.export_string(result) == expected_output
    end
  end
end
