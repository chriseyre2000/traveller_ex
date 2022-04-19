defmodule TravellerEx do
  @moduledoc """
  Documentation for `TravellerEx`.
  """

  @spec dice(integer) :: integer
  @doc "Rolls and sums dice"
  def dice(1) do
    1..6 |> Enum.random()
  end

  def dice(number) do
    1..number
    |> Enum.reduce(0, fn _, acc ->
      acc + dice(1)
    end)
  end

  def hex_encode(n) when is_integer(n) and n in 0..9, do: "#{n}"
  def hex_encode(n) when is_integer(n) and n in 10..15, do: "#{[?A + n - 10]}"

  def hex_decode(n) do
    Integer.parse(n)
    |> case do
      {number, ""} -> number
      :error -> case n do
        "A" -> 10
        "B" -> 11
        "C" -> 12
        "D" -> 13
        "E" -> 14
        "F" -> 15
      end
    end
  end

  def universal_personality_profile do
    1..6
    |> Enum.reduce("", fn _, acc ->
      "#{acc}#{dice(2) |> hex_encode()}"
    end)
  end
end
