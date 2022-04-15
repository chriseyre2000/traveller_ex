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

  @tag timeout: 50
  test "Can gain a commission the Army" do
    assert repeat_until(fn ->
      :ok == TravellerEx.Career.gain_commission(TravellerEx.Character.random(), TravellerEx.Profession.Army)
    end)
  end

  @tag timeout: 50
  test "Can fail to gain a commission the Army" do
    assert repeat_until(fn ->
      :failed == TravellerEx.Career.gain_commission(TravellerEx.Character.random(), TravellerEx.Profession.Army)
    end)
  end

  @tag timeout: 50
  test "Can be promoted in the Army" do
    assert repeat_until(fn ->
      :ok == TravellerEx.Career.gain_promotion(TravellerEx.Character.random(), TravellerEx.Profession.Army)
    end)
  end

  @tag timeout: 50
  test "Can fail to be promoted in the Army" do
    assert repeat_until(fn ->
      :failed == TravellerEx.Career.gain_promotion(TravellerEx.Character.random(), TravellerEx.Profession.Army)
    end)
  end

  @tag timeout: 50
  test "Can be forced to reenlist in the Army" do
    assert repeat_until(fn ->
      :madantory_reenlist == TravellerEx.Career.reenlist(TravellerEx.Character.random(), TravellerEx.Profession.Army)
    end)
  end

  @tag timeout: 50
  test "Can optionally reenlist in the Army" do
    assert repeat_until(fn ->
      :may_reenlist == TravellerEx.Career.reenlist(TravellerEx.Character.random(), TravellerEx.Profession.Army)
    end)
  end

  @tag timeout: 50
  test "Can be mustered out in the Army" do
    assert repeat_until(fn ->
      :muster_out == TravellerEx.Career.reenlist(TravellerEx.Character.random(), TravellerEx.Profession.Army)
    end)
  end
end
