defmodule TravellerEx.Planet do
  import TravellerEx, only: [dice: 1, hex_encode: 1, hex_decode: 1]
  defstruct [location: "", name: "", starport: "", size: "", atmosphere: "", hydrographics: "", population: "", government: "", law_level: "", tech_level: "", gas_giant: true, bases: [], travel_zone: :green ]

  def new() do
    %__MODULE__{}
  end

  def generate(location) do
    planet = new()

    planet = %{planet | location: location}

    planet = %{planet | starport: starport()}
    planet = %{planet | bases: bases(planet)}
    planet = %{planet | gas_giant: gas_giant?()}
    planet = %{planet | size: size()}
    planet = %{planet | atmosphere: atmosphere(planet)}
    planet = %{planet | hydrographics: hydrographics(planet)}
    planet = %{planet | population: population()}
    planet = %{planet | government: government(planet)}
    planet = %{planet | law_level: law_level(planet)}
    planet = %{planet | tech_level: tech_level(planet)}

    planet
  end

  def generate_string(location) do
    generate(location) |> to_string()
  end

  defp starport() do
    dice(2)
    |> case do
      2 -> :A
      3 -> :A
      4 -> :A
      5 -> :B
      6 -> :B
      7 -> :C
      8 -> :C
      9 -> :D
      10 -> :E
      11 -> :E
      12 -> :X
    end
  end

  defp bases(planet) do
    scout_modifier = cond do
      planet.starport == :A -> -3
      planet.starport == :B -> -2
      planet.starport == :C -> -1
      true -> 0
    end

    scout = (dice(2) + scout_modifier > 6)
    navy = planet.starport in [:A, :B] and (dice(2) > 7)

    cond do
      scout and navy -> [:scout, :navy]
      scout -> [:scout]
      navy -> [:navy]
      true -> []
    end
  end

  defp gas_giant? do
    dice(2) < 10
  end

  defp size() do
    (dice(2) - 2) |> hex_encode()
  end

  defp atmosphere(planet) do
    if planet.size == "0" do
      0
    else
      max(0, dice(2) - 7 + hex_decode(planet.size))
    end |> hex_encode()
  end

  defp hydrographics(planet) do
    decoded_atmos = hex_decode(planet.atmosphere)

    atmos_dm = cond do
      decoded_atmos < 2 -> -4
      decoded_atmos > 9 -> -4
      true -> 0
    end

    if planet.size == "0" do
      0
    else
      max(0, dice(2) - 7 + decoded_atmos + atmos_dm)
    end |> hex_encode()
  end

  defp population do
    dice(2) - 2 |> hex_encode()
  end

  defp government(planet) do
    max(0, dice(2) - 7 + hex_decode(planet.population)) |> hex_encode()
  end

  defp law_level(planet) do
    max(0, min(15, dice(2) - 7 + hex_decode(planet.government))) |> hex_encode()
  end

  defp tech_level(planet) do
    starport_mod = case planet.starport do
      :A -> 6
      :B -> 4
      :C -> 2
      :X -> -4
      _ -> 0
    end

    size_mod = case planet.size do
      "0" -> 2
      "1" -> 2
      "2" -> 1
      "3" -> 1
      "4" -> 1
      _ -> 0
    end

    atmos_mod = if hex_decode(planet.atmosphere) in 4..9, do: 0, else: 1

    hydro_mod = case planet.hydrographics do
      9 -> 1
      10 -> 2
      _ -> 0
    end

    population = hex_decode(planet.population)

    population_mod = cond do
      population in 1..5 -> 1
      population == 9 -> 2
      population == 10 -> 4
      true -> 0
    end

    government_mod = case planet.government do
      "0" -> 1
      "5" -> 1
      "D" -> -2
      _ -> 0
    end

    max(0, dice(1) + starport_mod + size_mod + atmos_mod + hydro_mod + population_mod + government_mod)

  end

  defimpl String.Chars, for: __MODULE__ do
    def to_string(planet) do
      "#{planet.location} #{planet.name} #{planet.starport}#{planet.size}#{planet.atmosphere}#{planet.hydrographics}#{planet.population}#{planet.government}#{planet.law_level}-#{planet.tech_level}"
    end
  end

end
