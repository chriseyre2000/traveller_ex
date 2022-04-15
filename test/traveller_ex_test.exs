defmodule TravellerExTest do
  use ExUnit.Case
  doctest TravellerEx

  @tag timeout: 5
  test "dice(1) will eventually return 1..6" do
    Stream.repeatedly(fn -> 1 end)
    |> Enum.reduce_while(1..6 |> Enum.to_list(), fn
      _, [] ->
        {:halt, []}

      _, acc ->
        {:cont, acc -- [TravellerEx.dice(1)]}
    end)

    assert true
  end

  @tag timeout: 10
  test "dice(2) will eventually return 2..12" do
    Stream.repeatedly(fn -> 1 end)
    |> Enum.reduce_while(2..12 |> Enum.to_list(), fn
      _, [] ->
        {:halt, []}

      _, acc ->
        {:cont, acc -- [TravellerEx.dice(2)]}
    end)

    assert true
  end
end
