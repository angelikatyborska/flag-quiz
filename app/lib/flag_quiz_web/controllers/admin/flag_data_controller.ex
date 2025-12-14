defmodule FlagQuizWeb.Admin.FlagDataController do
  use FlagQuizWeb, :controller

  @region_ids %{
    "africa" => "1",
    "americas" => "2",
    "asia" => "3",
    "europe" => "4",
    "oceania" => "5",
    "polar" => "6"
  }

  def continents(conn, _params) do
    continents =
      Path.wildcard("./priv/data/*")
      |> Enum.map(fn path -> String.split(path, "/", trim: true) |> List.last() end)

    render(conn, :continents, %{continents: continents})
  end

  def countries(conn, params) do
    continent = Map.get(params, "continent")
    region_id = Map.get(@region_ids, continent)

    countries =
      Place.get_countries()
      |> Enum.filter(&(&1.csc_region_id == region_id))
      |> Enum.sort(fn a, b -> a.name < b.name end)

    country_flags =
      Path.wildcard("./priv/data/#{continent}/*")
      |> Enum.map(fn path ->
        country =
          String.split(path, "/", trim: true) |> List.last()

        flags = load_data_for_country(continent, country)
        {country, flags}
      end)
      |> Enum.into(%{})

    render(conn, :countries, %{
      continent: continent,
      countries: countries,
      country_flags: country_flags
    })
  end

  def flags(conn, params) do
    continent = Map.get(params, "continent")
    country_code = Map.get(params, "country")
    country = Place.get_country(country_code: String.upcase(country_code))

    flags = load_data_for_country(continent, country_code)

    render(conn, :flags, %{continent: continent, country: country, flags: flags})
  end

  # TODO: move to a dedicated module
  defp load_data_for_country(continent, country) do
    case File.read("./priv/data/#{continent}/#{country}/index.json") do
      {:ok, file} -> Jason.decode!(file)
      {:error, _} -> []
    end
  end
end
