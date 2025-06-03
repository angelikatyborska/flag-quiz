panama_flag_string = File.read!("./lib/flag_quiz/data/pa.svg")
cameroon_flag_string = File.read!("./lib/flag_quiz/data/cm.svg")

# TODO: generating those should probably be part of the app build process

{:ok, panama_flag} = FlagQuiz.Svg.parse_string(panama_flag_string)
{:ok, cameroon_flag} = FlagQuiz.Svg.parse_string(cameroon_flag_string)

# See https://hexdocs.pm/elixir/1.18.3/Record.html#is_record/2
# See https://stackoverflow.com/questions/17345939/elixir-and-erlang-records-pattern-matching

FlagQuiz.Data.Pa.versions
|> Enum.with_index()
|> Enum.each(fn {version, index} ->
modified_flag = FlagQuiz.Flag.Modification.apply_modifications(panama_flag, version)

File.write!("./output/pa-#{index}.svg", FlagQuiz.Svg.export_string(modified_flag))
end)

FlagQuiz.Data.Cm.versions
|> Enum.with_index()
|> Enum.each(fn {version, index} ->
  modified_flag = FlagQuiz.Flag.Modification.apply_modifications(cameroon_flag, version)

  File.write!("./output/cm-#{index}.svg", FlagQuiz.Svg.export_string(modified_flag))
end)
