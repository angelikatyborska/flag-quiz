defmodule FlagQuiz.SvgTest do
  use ExUnit.Case

  @svg_file "./test/fixtures/pa.svg"
  @svg_content File.read!(@svg_file)

  describe "parse_string" do
    test "parses an svg" do
      assert {:ok, doc} = FlagQuiz.Svg.parse_string(@svg_content)

      assert {:xmlElement, :svg, :svg, [], {:xmlNamespace, :"http://www.w3.org/2000/svg", []}, [],
              1,
              [
                {:xmlAttribute, :xmlns, [], [], [], [svg: 1], 1, [],
                 ~c"http://www.w3.org/2000/svg", false},
                {:xmlAttribute, :width, [], [], [], [svg: 1], 2, [], ~c"900", false},
                {:xmlAttribute, :height, [], [], [], [svg: 1], 3, [], ~c"600", false},
                {:xmlAttribute, :viewBox, [], [], [], [svg: 1], 4, [], ~c"0 0 12 8", false}
              ],
              [
                {:xmlText, [svg: 1], 1, [], ~c"\n  ", :text},
                {:xmlElement, :g, :g, [], {:xmlNamespace, :"http://www.w3.org/2000/svg", []},
                 [svg: 1], 2,
                 [{:xmlAttribute, :id, [], [], [], [g: 2, svg: 1], 1, [], ~c"flag", false}],
                 [
                   {:xmlText, [g: 2, svg: 1], 1, [], ~c"\n    ", :text},
                   {:xmlElement, :path, :path, [],
                    {:xmlNamespace, :"http://www.w3.org/2000/svg", []}, [g: 2, svg: 1], 2,
                    [
                      {:xmlAttribute, :fill, [], [], [], [path: 2, g: 2, svg: 1], 1, [], ~c"#fff",
                       false},
                      {:xmlAttribute, :d, [], [], [], [path: 2, g: 2, svg: 1], 2, [],
                       ~c"m0 4V0h6l6 4v4H6z", false}
                    ], [], [], _, :undeclared},
                   {:xmlText, [g: 2, svg: 1], 3, [], ~c"\n    ", :text},
                   {:xmlElement, :path, :path, [],
                    {:xmlNamespace, :"http://www.w3.org/2000/svg", []}, [g: 2, svg: 1], 4,
                    [
                      {:xmlAttribute, :fill, [], [], [], [path: 4, g: 2, svg: 1], 1, [],
                       ~c"#da121a", false},
                      {:xmlAttribute, :d, [], [], [], [path: 4, g: 2, svg: 1], 2, [],
                       ~c"M 6 0 L 12 0 L 12 4 L 6 4 L 6 0 Z", false}
                    ], [], [], _, :undeclared},
                   {:xmlText, [g: 2, svg: 1], 5, [], ~c"\n    ", :text},
                   {:xmlElement, :path, :path, [],
                    {:xmlNamespace, :"http://www.w3.org/2000/svg", []}, [g: 2, svg: 1], 6,
                    [
                      {:xmlAttribute, :id, [], [], [], [path: 6, g: 2, svg: 1], 1, [], ~c"star1",
                       false},
                      {:xmlAttribute, :fill, [], [], [], [path: 6, g: 2, svg: 1], 2, [],
                       ~c"#da121a", false},
                      {:xmlAttribute, :d, [], [], [], [path: 6, g: 2, svg: 1], 3, [],
                       ~c"M 9 5 L 9.6498 7 L 7.9485 5.7639 L 10.0515 5.7639 L 8.3502 7 L 9 5 Z",
                       false}
                    ], [], [], _, :undeclared},
                   {:xmlText, [g: 2, svg: 1], 7, [], ~c"\n    ", :text},
                   {:xmlElement, :path, :path, [],
                    {:xmlNamespace, :"http://www.w3.org/2000/svg", []}, [g: 2, svg: 1], 8,
                    [
                      {:xmlAttribute, :fill, [], [], [], [path: 8, g: 2, svg: 1], 1, [],
                       ~c"#072357", false},
                      {:xmlAttribute, :d, [], [], [], [path: 8, g: 2, svg: 1], 2, [],
                       ~c"M 0 4 L 6 4 L 6 8 L 0 8 L 0 4 Z", false}
                    ], [], [], _, :undeclared},
                   {:xmlText, [g: 2, svg: 1], 9, [], ~c"\n    ", :text},
                   {:xmlElement, :path, :path, [],
                    {:xmlNamespace, :"http://www.w3.org/2000/svg", []}, [g: 2, svg: 1], 10,
                    [
                      {:xmlAttribute, :id, [], [], [], [path: 10, g: 2, svg: 1], 1, [], ~c"star2",
                       false},
                      {:xmlAttribute, :fill, [], [], [], [path: 10, g: 2, svg: 1], 2, [],
                       ~c"#072357", false},
                      {:xmlAttribute, :d, [], [], [], [path: 10, g: 2, svg: 1], 3, [],
                       ~c"M 3 1 L 3.6498 3 L 1.9485000000000001 1.7639 L 4.051500000000001 1.7639 L 2.3502 3 L 3 1 Z",
                       false}
                    ], [], [], _, :undeclared},
                   {:xmlText, [g: 2, svg: 1], 11, [], ~c"\n  ", :text}
                 ], [], _, :undeclared},
                {:xmlText, [svg: 1], 3, [], ~c"\n", :text}
              ], [], _, :undeclared} = doc
    end
  end

  describe "set_attribute_on_element_with_id" do
    test "when element with id not found" do
      input = """
      <svg xmlns="http://www.w3.org/2000/svg" width="900" height="600" viewBox="0 0 12 8">
      <g>
        <g id="flag">
          <path fill="#fff" d="m0 4V0h6l6 4v4H6z"/>
        </g>
        <g></g>
      </g>
      </svg>
      """

      {:ok, doc} = FlagQuiz.Svg.parse_string(input)

      assert_raise(
        RuntimeError,
        "Operation set_attribute_on_element_with_id on #flagz (transform=rotate(180)) did not modify the element",
        fn ->
          FlagQuiz.Svg.set_attribute_on_element_with_id(doc, "flagz", :transform, "rotate(180)")
        end
      )
    end

    test "adds the attribute" do
      input = """
      <svg xmlns="http://www.w3.org/2000/svg" width="900" height="600" viewBox="0 0 12 8">
      <g>
        <g id="flag">
          <path fill="#fff" d="m0 4V0h6l6 4v4H6z"/>
        </g>
        <g></g>
      </g>
      </svg>
      """

      expected_output = """
      <svg xmlns="http://www.w3.org/2000/svg" width="900" height="600" viewBox="0 0 12 8">
      <g>
        <g id="flag" transform="rotate(180)">
          <path fill="#fff" d="m0 4V0h6l6 4v4H6z"/>
        </g>
        <g/>
      </g>
      </svg>
      """

      {:ok, doc} = FlagQuiz.Svg.parse_string(input)
      doc = FlagQuiz.Svg.set_attribute_on_element_with_id(doc, "flag", :transform, "rotate(180)")
      assert FlagQuiz.Svg.export_string(doc) == expected_output
    end

    test "overwrites the attribute" do
      input = """
      <svg xmlns="http://www.w3.org/2000/svg" width="900" height="600" viewBox="0 0 12 8">
      <g>
        <g id="flag" transform="rotate(45)">
          <path fill="#fff" d="m0 4V0h6l6 4v4H6z"/>
        </g>
        <g></g>
      </g>
      </svg>
      """

      expected_output = """
      <svg xmlns="http://www.w3.org/2000/svg" width="900" height="600" viewBox="0 0 12 8">
      <g>
        <g id="flag" transform="rotate(180)">
          <path fill="#fff" d="m0 4V0h6l6 4v4H6z"/>
        </g>
        <g/>
      </g>
      </svg>
      """

      {:ok, doc} = FlagQuiz.Svg.parse_string(input)
      doc = FlagQuiz.Svg.set_attribute_on_element_with_id(doc, "flag", :transform, "rotate(180)")
      assert FlagQuiz.Svg.export_string(doc) == expected_output
    end
  end

  describe "export_string" do
    test "parse and export string produces the original file" do
      {:ok, doc} = FlagQuiz.Svg.parse_string(@svg_content)

      assert FlagQuiz.Svg.export_string(doc) == @svg_content
    end
  end
end
