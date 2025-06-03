countries = ["au", "pa", "cm", "ga"]

Enum.each(countries, fn code ->
  flag_string = File.read!("./lib/flag_quiz/data/#{code}.svg")
  {:ok, flag} = FlagQuiz.Svg.parse_string(flag_string)
  module = "Elixir.FlagQuiz.Data.#{String.upcase(code)}"
  versions = apply(String.to_existing_atom(module), :versions, [])

  versions
  |> Enum.with_index()
  |> Enum.each(fn {version, index} ->
    modified_flag = FlagQuiz.Flag.Modification.apply_modifications(flag, version)

    File.write!("./output/#{code}-#{index}.svg", FlagQuiz.Svg.export_string(modified_flag))
  end)

end)
