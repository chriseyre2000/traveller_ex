defmodule TravellerEx.Subsector do
  def generate() do
    for x <- 1..8, y <- 1..10, TravellerEx.dice(1) < 4,  do: "0#{x}" <> String.pad_leading("#{y}", 2, "0") |> TravellerEx.Planet.generate_string()
  end
end
