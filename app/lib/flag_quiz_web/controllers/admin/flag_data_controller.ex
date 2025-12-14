defmodule FlagQuizWeb.Admin.FlagDataController do
  use FlagQuizWeb, :controller

  def continents(conn, params) do
    continents =
      Path.wildcard("./priv/data/*")
      |> Enum.map(fn path -> String.split(path, "/", trim: true) |> List.last() end)

    dbg(continents)

    render(conn, :continents, %{continents: continents})
  end

  def countries(conn, params) do
    continent = Map.get(params, "continent")

    countries =
      Path.wildcard("./priv/data/#{continent}/*")
      |> Enum.map(fn path -> String.split(path, "/", trim: true) |> List.last() end)

    render(conn, :countries, %{continent: continent, countries: countries})
  end

  def flags(conn, params) do
    continent = Map.get(params, "continent")
    country = Map.get(params, "country")

    flags = File.read!("./priv/data/#{continent}/#{country}/index.json")
    |> Jason.decode!()

    render(conn, :flags, %{continent: continent, country: country, flags: flags})
  end
end
