# TODO: autoread country list
countries = ["ao", "au", "cl", "pa", "cm", "mn", "ga"]

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

  modification_combinations =
    FlagQuiz.Flag.Modification.generate_combinations(
      available_modifications,
      modification_conflicts
    )

  versions =
    [%FlagQuiz.Flag.Version{modifications: []}] ++
      Enum.map(modification_combinations, fn modifications ->
        %FlagQuiz.Flag.Version{modifications: modifications}
      end)

  data =
    versions
    |> Enum.map(fn version ->
      modified_flag =
        Enum.reduce(version.modifications, flag, fn modification, acc ->
          FlagQuiz.Flag.Tweak.apply_tweaks(acc, modification)
        end)

      modifications = Enum.map(version.modifications, & &1.id)

      id = :crypto.hash(:md5, "#{code}.#{Enum.join(modifications, ",")}") |> Base.encode16(case: :lower)
      filename = "#{code}.#{id}.svg"

      File.write!(
        Path.join(output_dir, "/#{code}/#{filename}"),
        FlagQuiz.Svg.export_string(modified_flag)
      )

      %{id: id, modifications: modifications, filename: filename}
    end)

  File.write!(Path.join(output_dir, "/#{code}/index.json"), Jason.encode!(data))

  imgs =
    data
    |> Enum.map(fn flag -> "<img src=\"./#{flag.filename}\" />" end)

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
