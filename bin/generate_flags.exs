countries = ["au", "pa", "cm", "ga"]

Enum.each(countries, fn code ->
  flag_string = File.read!("./lib/flag_quiz/data/#{code}.svg")
  {:ok, flag} = FlagQuiz.Svg.parse_string(flag_string)
  module = "Elixir.FlagQuiz.Data.#{String.upcase(code)}"
  versions = [%FlagQuiz.Flag.Version{modifications: []}] ++ apply(String.to_existing_atom(module), :versions, [])

  versions
  |> Enum.with_index()
  |> Enum.each(fn {version, index} ->
    modified_flag = FlagQuiz.Flag.Modification.apply_modifications(flag, version)

    File.write!("./output/#{code}-#{index}.svg", FlagQuiz.Svg.export_string(modified_flag))
  end)

  imgs = versions |> Enum.with_index() |> Enum.shuffle() |> Enum.map(fn {_, index} -> "<img src=\"./#{code}-#{index}.svg\" />" end)
  html = """
  <!DOCTYPE html>
  <html>
  <head>
  <title>#{apply(String.to_existing_atom(module), :name, [])}</title>
  <style>
    html {
      margin: 0;
      padding: 0;
    }

    img {
      max-width: 100%;
      height: auto;
    }
  </style>
  </head>
  <body>
  <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; padding: 10px;">
  #{imgs}
  </div>
  </body>
  </html>
  """
  File.write("./output/#{code}.html", html)

end)
