panama_data_string = File.read!("./data/pa.json")
panama_flag_string = File.read!("./data/pa.svg")

# TODO: generating those should probably be part of the app build process

{:ok, panama_data} = Jason.decode(panama_data_string)
{:ok, panama_flag} = FlagQuiz.Svg.parse_string(panama_flag_string)

zoom = fn doc, mod ->
  %{"params" => %{
    "value" => value,
    "objects" => objects
  }} = mod
  Enum.reduce(objects, doc, fn object, acc ->
    acc
    |> FlagQuiz.Svg.set_attribute_on_element_with_id(object, :style, "transform: scale(#{value}); transform-box: fill-box; transform-origin: center")
  end)
end

flip = fn doc, mod ->
  %{"params" => %{
    "plane" => plane,
    "objects" => objects
  }} = mod
  Enum.reduce(objects, doc, fn object, acc ->
    value = if plane === "horizontal" do
      "-1, 1"
    else
      "1, -1"
    end

    acc
    |> FlagQuiz.Svg.set_attribute_on_element_with_id(object, :style, "transform: scale(#{value}); transform-box: fill-box; transform-origin: center")
  end)
end

rotate = fn doc, mod ->
  %{"params" => %{
    "angle" => value,
    "objects" => objects
  }} = mod
  Enum.reduce(objects, doc, fn object, acc ->

    acc
    |> FlagQuiz.Svg.set_attribute_on_element_with_id(object, :style, "transform: rotate(#{value}deg); transform-box: fill-box; transform-origin: center")
  end)
end

# TODO: move this to a module
panama_data["versions"]
|> Enum.with_index()
|> Enum.each(fn {version, index} ->
modified_flag =
Enum.reduce(version["modifications"], panama_flag, fn mod, doc ->
  case mod["type"] do
    "zoom" -> zoom.(doc, mod)
    "flip" -> flip.(doc, mod)
    "rotate" -> rotate.(doc, mod)
    _ ->
      nil
  end
end)

File.write!("./output/pa-#{index}.svg", FlagQuiz.Svg.export_string(modified_flag))
end)
