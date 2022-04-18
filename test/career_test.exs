defmodule TravellerEx.CareerTest do
  use ExUnit.Case
  import TestHelpers

  @tag timeout: 20
  test "Can generate character" do
    assert repeat_until(fn ->
      try do
        character = TravellerEx.Career.generate(3, :army)
        character.age > 18
      catch
        "You are dead" -> false
      end

    end)
  end

  @tag timeout: 20
  test "Can die" do
    assert repeat_until(fn ->
      try do
        TravellerEx.Career.generate(3, :army)
        false
      catch
        x -> x == "You are dead"
      end
    end)
  end

  @tag timeout: 50
  test "Can get a different profession when aiming for army" do
    assert repeat_until(fn ->
      try do
        character = TravellerEx.Career.generate(3, :army)
        character.profession != :army
      catch
        "You are dead" -> false
      end
    end)
  end

  @tag timeout: 50
  test "Can get a different profession when aiming for navy" do
    assert repeat_until(fn ->
      try do
        character = TravellerEx.Career.generate(3, :navy)
        character.profession != :navy
      catch
        "You are dead" -> false
      end
    end)
  end
end
