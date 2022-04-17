defmodule TravellerEx.Profession.Navy do
  @behaviour TravellerEx.Profession
  import TravellerEx.Profession.Skills

  @impl TravellerEx.Profession
  def enlist_threshold(%TravellerEx.Character{} = character) do
    value = 8
    value = if character.intelligence >= 8 do
      value - 1
    else
      value
    end
    if character.education >= 9 do
      value - 2
    else
      value
    end
  end

  @impl TravellerEx.Profession
  def survive_threshold(%TravellerEx.Character{} = character) do
    value = 5
    if character.intelligence >= 7 do
      value - 2
    else
      value
    end
  end

  @impl TravellerEx.Profession
  def commission_threshold(%TravellerEx.Character{} = character) do
    value = 10
    if (character.social_standing >= 9) do
      value - 1
    else
      value
    end
  end

  @impl TravellerEx.Profession
  def promotion_threshold(%TravellerEx.Character{} = character) do
    value = 8
    if character.education >= 8 do
      value - 1
    else
      value
    end
  end

  @impl TravellerEx.Profession
  def reenlist_threshold(%TravellerEx.Character{}) do
    6
  end

  @impl TravellerEx.Profession
  def personal_development(%TravellerEx.Character{}) do
    [
      increment_attribute(:strength),
      increment_attribute(:dexterity),
      increment_attribute(:endurance),
      increment_attribute(:intelligence),
      increment_attribute(:education),
      increment_attribute(:social_standing),
    ] |> Enum.random()
  end

  @impl TravellerEx.Profession
  def service_skills(%TravellerEx.Character{}) do
    [
      increment_skill(:ships_boat),
      increment_skill(:vacc_suit),
      increment_skill(:fwd_observer),
      increment_skill(:gunnery),
      increment_skill(:blade_combat),
      increment_skill(:gun_combat),
    ]
    |> Enum.random()
  end

  @impl TravellerEx.Profession
  def advanced_education(%TravellerEx.Character{education: education}) when education >= 8 do
    [
      increment_skill(:medical),
      increment_skill(:navigation),
      increment_skill(:engineering),
      increment_skill(:computer),
      increment_skill(:pilot),
      increment_skill(:admin),
    ]
    |> Enum.random()
  end

  def advanced_education(%TravellerEx.Character{}) do
    [
      increment_skill(:vacc_suit),
      increment_skill(:mechanical),
      increment_skill(:electronic),
      increment_skill(:engineering),
      increment_skill(:gunnery),
      increment_skill(:jack_o_t),
    ]
    |> Enum.random()
  end

  @impl TravellerEx.Profession
  def base_skills(character = %TravellerEx.Character{}) do
    character
  end

  @impl TravellerEx.Profession
  def promotion_skills(character, 4, 5) do
    increment_attribute(:social_standing).(character)
  end
  def promotion_skills(character, 5, 6) do
    increment_attribute(:social_standing).(character)
  end
  def promotion_skills(character, _from, _to) do
    character
  end

  @impl TravellerEx.Profession
  def benefits(character = %TravellerEx.Character{}) do
    benefit_list = [
      add_item(:low_passage),
      increment_attribute(:intelligence, 1),
      increment_attribute(:education, 2),
      add_item(:blade),
      add_item(:travellers),
      add_item(:high_passage),
      increment_attribute(:social_standing, 2),
    ]

    bonus = if 5 >= character.rank do
      benefit_list |> Enum.drop(1)
    else
      benefit_list |> Enum.drop(-1)
    end
    |> Enum.random()

    bonus.(character)
  end

  @impl TravellerEx.Profession
  def cash_benefits(character = %TravellerEx.Character{}) do
    amounts = [
      1_000,
      5_000,
      5_000,
      10_000,
      20_000,
      50_000,
      50_000
    ]

    amount = if character.skills |> Map.has_key?(:gambling) do
      amounts |> Enum.drop(1)
    else
      amounts |> Enum.take(6)
    end |> Enum.random()

    %TravellerEx.Character{character| credits: character.credits + amount}
  end

  def rank(character= %TravellerEx.Character{}) do
    case character.rank do
      1 -> "Ensign"
      2 -> "Lieutenant"
      3 -> "Lt Commander"
      4 -> "Commander"
      5 -> "Captain"
      6 -> "Admiral"
      _ -> "Private"
    end
  end
end
