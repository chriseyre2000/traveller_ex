defmodule TravellerEx.Profession.Other do
  @behaviour TravellerEx.Profession
  import TravellerEx.Profession.Skills

  @impl TravellerEx.Profession
  def enlist_threshold(%TravellerEx.Character{} = character) do
    3
  end

  @impl TravellerEx.Profession
  def survive_threshold(%TravellerEx.Character{} = character) do
    value = 5
    if character.intelligence >= 9 do
      value - 2
    else
      value
    end
  end

  @impl TravellerEx.Profession
  def commission_threshold(%TravellerEx.Character{}) do
    13
  end

  @impl TravellerEx.Profession
  def promotion_threshold(%TravellerEx.Character{}) do
    13
  end

  @impl TravellerEx.Profession
  def reenlist_threshold(%TravellerEx.Character{}) do
    5
  end

  @impl TravellerEx.Profession
  def personal_development(%TravellerEx.Character{}) do
    [
      increment_attribute(:strength),
      increment_attribute(:dexterity),
      increment_attribute(:endurance),
      increment_skill(:blade_combat),
      increment_skill(:brawling),
      increment_attribute(:social_standing, -1),
    ] |> Enum.random()
  end

  @impl TravellerEx.Profession
  def service_skills(%TravellerEx.Character{}) do
    [
      increment_skill(:vehicle),
      increment_skill(:gambling),
      increment_skill(:brawling),
      increment_skill(:bribery),
      increment_skill(:blade_combat),
      increment_skill(:gun_combat),
    ]
    |> Enum.random()
  end

  @impl TravellerEx.Profession
  def advanced_education(%TravellerEx.Character{education: education}) when education >= 8 do
    [
      increment_skill(:medical),
      increment_skill(:forgery),
      increment_skill(:electronics),
      increment_skill(:computer),
      increment_skill(:streetwise),
      increment_skill(:jack_o_t),
    ]
    |> Enum.random()
  end

  def advanced_education(%TravellerEx.Character{}) do
    [
      increment_skill(:streetwise),
      increment_skill(:mechanical),
      increment_skill(:electronic),
      increment_skill(:gambling),
      increment_skill(:brawling),
      increment_skill(:forgery),
    ]
    |> Enum.random()
  end

  @impl TravellerEx.Profession
  def base_skills(character = %TravellerEx.Character{}) do
    character
  end

  @impl TravellerEx.Profession
  def promotion_skills(character, _from, _to) do
    character
  end

  @impl TravellerEx.Profession
  def benefits(character = %TravellerEx.Character{}) do
    benefit_list = [
      add_item(:low_passage),
      increment_attribute(:intelligence, 1),
      increment_attribute(:education, 1),
      add_item(:gun),
      add_item(:high_passage),
      fn x -> x end,
    ]

    bonus = benefit_list
    |> Enum.random()

    bonus.(character)
  end

  @impl TravellerEx.Profession
  def cash_benefits(character = %TravellerEx.Character{}) do
    amounts = [
      1_000,
      5_000,
      10_000,
      10_000,
      10_000,
      50_000,
      100_000
    ]

    amount = if character.skills |> Map.has_key?(:gambling) do
      amounts |> Enum.drop(1)
    else
      amounts |> Enum.take(6)
    end |> Enum.random()

    %TravellerEx.Character{character| credits: character.credits + amount}
  end

  def rank(%TravellerEx.Character{}) do
    ""
  end
end
