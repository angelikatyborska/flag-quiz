countries = ["ao", "au", "pa", "cm", "mn", "ga"]

output_dir = "./output"

File.rm_rf(output_dir)
File.mkdir(output_dir)

Enum.each(countries, fn code ->
   File.mkdir(Path.join(output_dir, "/#{code}"))

  flag_string = File.read!("./lib/flag_quiz/input/#{code}.svg")
  {:ok, flag} = FlagQuiz.Svg.parse_string(flag_string)
  module = "Elixir.FlagQuiz.Input.#{String.upcase(code)}"
  available_modifications = apply(String.to_existing_atom(module), :modifications, [])
  modification_conflicts = apply(String.to_existing_atom(module), :modification_conflicts, [])
  modification_combinations = FlagQuiz.Flag.Modification.generate_combinations(available_modifications, modification_conflicts)

  versions = [%FlagQuiz.Flag.Version{modifications: []}] ++ Enum.map(modification_combinations, fn modifications -> %FlagQuiz.Flag.Version{modifications: modifications} end)

  versions
  |> Enum.with_index()
  |> Enum.each(fn {version, index} ->

    modified_flag =
      Enum.reduce(version.modifications, flag, fn modification, acc ->
        FlagQuiz.Flag.Tweak.apply_tweaks(acc, modification)
      end)

      # TODO: put input and output in dir per country
    File.write!(Path.join(output_dir, "/#{code}/#{index}.svg"), FlagQuiz.Svg.export_string(modified_flag))
  end)

  imgs =
    versions
     |> Enum.with_index()
#    |> Enum.shuffle()
    |> Enum.map(fn {_, index} -> "<img src=\"./#{index}.svg\" />" end)
  html = """
  <!DOCTYPE html>
  <html>
  <head>
  <title>#{apply(String.to_existing_atom(module), :name, [])}</title>
  <style>
    html {
      margin: 0;
      padding: 0;
      background-color: lightgray;
    }

    img {
      max-width: 100%;
      height: auto;
    }
  </style>
  </head>
  <body>
  <div style="display: grid; grid-template-columns: repeat(8, 1fr); align-items: center; gap: 10px; padding: 10px;">
  #{imgs}
  </div>
  </body>
  </html>
  """
  File.write(Path.join(output_dir, "/#{code}/index.html"), html)

end)
