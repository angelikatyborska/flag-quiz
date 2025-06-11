defmodule FlagQuiz.Flag.TweakTest do
  use ExUnit.Case
  alias FlagQuiz.Flag.Tweak

  describe "apply_tweak" do
    test "applies multiple tweaks" do
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
        <g id="obj3" style="transform: scale(-1, 1); transform-box: fill-box; transform-origin: center"><circle cx="10" cy="10" r="10"/></g>
      </svg>
      """

      {:ok, doc} = FlagQuiz.Svg.parse_string(input)

      tweaks = [
        %{type: :zoom, params: %{value: 0.5, objects: ["obj1"]}},
        %{type: :flip, params: %{plane: :horizontal, objects: ["obj3"]}}
      ]

      result =
        FlagQuiz.Flag.Tweak.apply_tweak(doc, %FlagQuiz.Flag.Modification{
          tweaks: tweaks
        })

      assert FlagQuiz.Svg.export_string(result) == expected_output
    end
  end

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

      result = Tweak.zoom(doc, mod)

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

      result = Tweak.flip(doc, mod)

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

      result = Tweak.flip(doc, mod)

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

      result = Tweak.rotate(doc, mod)

      assert FlagQuiz.Svg.export_string(result) == expected_output
    end
  end

  describe "swap_fill" do
    test "swaps fill colors between two groups of objects" do
      input = """
      <svg xmlns="http://www.w3.org/2000/svg" width="900" height="600" viewBox="0 0 12 8">
        <g><circle id="obj1" cx="50" cy="50" r="50" fill="#c0ffee"/></g>
        <g><circle id="obj2" cx="30" cy="30" r="30" fill="#baddad"/></g>
        <g><circle id="obj3" cx="10" cy="10" r="10" fill="#c0ffee"/></g>
      </svg>
      """

      expected_output = """
      <svg xmlns="http://www.w3.org/2000/svg" width="900" height="600" viewBox="0 0 12 8">
        <g><circle id="obj1" cx="50" cy="50" r="50" fill="#baddad"/></g>
        <g><circle id="obj2" cx="30" cy="30" r="30" fill="#c0ffee"/></g>
        <g><circle id="obj3" cx="10" cy="10" r="10" fill="#baddad"/></g>
      </svg>
      """

      {:ok, doc} = FlagQuiz.Svg.parse_string(input)

      mod = %{
        params: %{
          objects1: ["obj1", "obj3"],
          objects2: ["obj2"]
        }
      }

      result = Tweak.swap_fill(doc, mod)

      assert FlagQuiz.Svg.export_string(result) == expected_output
    end
  end

  describe "change_fill" do
    test "changes fill color of a group of objects" do
      input = """
      <svg xmlns="http://www.w3.org/2000/svg" width="900" height="600" viewBox="0 0 12 8">
        <g><circle id="obj1" cx="50" cy="50" r="50" fill="#c0ffee"/></g>
        <g><circle id="obj2" cx="30" cy="30" r="30" fill="#baddad"/></g>
        <g><circle id="obj3" cx="10" cy="10" r="10" fill="#c0ffee"/></g>
      </svg>
      """

      expected_output = """
      <svg xmlns="http://www.w3.org/2000/svg" width="900" height="600" viewBox="0 0 12 8">
        <g><circle id="obj1" cx="50" cy="50" r="50" fill="#ffffff"/></g>
        <g><circle id="obj2" cx="30" cy="30" r="30" fill="#ffffff"/></g>
        <g><circle id="obj3" cx="10" cy="10" r="10" fill="#c0ffee"/></g>
      </svg>
      """

      {:ok, doc} = FlagQuiz.Svg.parse_string(input)

      mod = %{
        params: %{
          objects: ["obj1", "obj2"],
          value: "#ffffff"
        }
      }

      result = Tweak.change_fill(doc, mod)

      assert FlagQuiz.Svg.export_string(result) == expected_output
    end
  end

  describe "add_stroke" do
    test "adds stroke to specified objects" do
      input = """
      <svg xmlns="http://www.w3.org/2000/svg" width="900" height="600" viewBox="0 0 12 8">
        <g><circle id="obj1" cx="50" cy="50" r="50" fill="#ff0000"/></g>
        <g><circle id="obj2" cx="30" cy="30" r="30" fill="#00ff00"/></g>
        <g><circle id="obj3" cx="10" cy="10" r="10" fill="#0000ff"/></g>
      </svg>
      """

      expected_output = """
      <svg xmlns="http://www.w3.org/2000/svg" width="900" height="600" viewBox="0 0 12 8">
        <g><circle id="obj1" cx="50" cy="50" r="50" fill="#ff0000" stroke="#000000" stroke-width="2"/></g>
        <g><circle id="obj2" cx="30" cy="30" r="30" fill="#00ff00" stroke="#000000" stroke-width="2"/></g>
        <g><circle id="obj3" cx="10" cy="10" r="10" fill="#0000ff"/></g>
      </svg>
      """

      {:ok, doc} = FlagQuiz.Svg.parse_string(input)

      mod = %{
        params: %{
          objects: ["obj1", "obj2"],
          color: "#000000",
          width: 2
        }
      }

      result = Tweak.add_stroke(doc, mod)

      assert FlagQuiz.Svg.export_string(result) == expected_output
    end
  end

  describe "hide" do
    test "hides specified objects" do
      input = """
      <svg xmlns="http://www.w3.org/2000/svg" width="900" height="600" viewBox="0 0 12 8">
        <g id="obj1"><circle cx="50" cy="50" r="50" fill="#ff0000"/></g>
        <g id="obj2"><circle cx="30" cy="30" r="30" fill="#00ff00"/></g>
        <g id="obj3"><circle cx="10" cy="10" r="10" fill="#0000ff"/></g>
      </svg>
      """

      expected_output = """
      <svg xmlns="http://www.w3.org/2000/svg" width="900" height="600" viewBox="0 0 12 8">
        <g id="obj1" style="display: none"><circle cx="50" cy="50" r="50" fill="#ff0000"/></g>
        <g id="obj2" style="display: none"><circle cx="30" cy="30" r="30" fill="#00ff00"/></g>
        <g id="obj3"><circle cx="10" cy="10" r="10" fill="#0000ff"/></g>
      </svg>
      """

      {:ok, doc} = FlagQuiz.Svg.parse_string(input)

      mod = %{
        params: %{
          objects: ["obj1", "obj2"]
        }
      }

      result = Tweak.hide(doc, mod)

      assert FlagQuiz.Svg.export_string(result) == expected_output
    end
  end
end
