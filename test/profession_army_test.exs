defmodule TravellerEx.ProfessionArmyTest do
  use ExUnit.Case
  import TestHelpers

  @tag timeout: 10
  test "Can always enlist in Army" do
    character = TravellerEx.Character.from_upp("FFFFFF")
    assert repeat_until(fn ->
      :ok == TravellerEx.Career.enlist(character, TravellerEx.Profession.Army)
    end)
  end

  @tag timeout: 10
  test "Can fail to enlist in Army" do
    character = TravellerEx.Character.from_upp("222222")
    assert repeat_until(fn ->
      :failed == TravellerEx.Career.enlist(character, TravellerEx.Profession.Army)
    end)
  end

  @tag timeout: 20
  test "Can survive in Army" do
    assert repeat_until(fn ->
      :ok == TravellerEx.Career.survive(TravellerEx.Character.random(), TravellerEx.Profession.Army)
    end)
  end

  @tag timeout: 50
  test "Can die in Army" do
    assert repeat_until(fn ->
      :died == TravellerEx.Career.survive(TravellerEx.Character.random(), TravellerEx.Profession.Army)
    end)
  end


end
