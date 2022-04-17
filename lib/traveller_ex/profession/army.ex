defmodule TravellerEx.Profession.Army do
  @behaviour TravellerEx.Profession
  import TravellerEx.Profession.Skills

  @impl TravellerEx.Profession
  def enlist_threshold(%TravellerEx.Character{} = character) do
    value = 5
    value = if character.dexterity >= 6 do
      value - 1
    else
      value
    end
    if character.endurance >= 5 do
      value - 2
    else
      value
    end
  end

  @impl TravellerEx.Profession
  def survive_threshold(%TravellerEx.Character{} = character) do
    value = 5
    if character.education >= 6 do
      value - 2
    else
      value
    end
  end

  @impl TravellerEx.Profession
  def commission_threshold(%TravellerEx.Character{} = character) do
    value = 5
    if (character.endurance >= 7) do
      value - 1
    else
      value
    end
  end

  @impl TravellerEx.Profession
  def promotion_threshold(%TravellerEx.Character{} = character) do
    value = 6
    if character.education >= 7 do
      value - 1
    else
      value
    end
  end

  @impl TravellerEx.Profession
  def reenlist_threshold(%TravellerEx.Character{}) do
    7
  end

  @impl TravellerEx.Profession
  def personal_development(%TravellerEx.Character{}) do
    [
      increment_attribute(:strength),
      increment_attribute(:dexterity),
      increment_attribute(:endurance),
      increment_skill(:gambling),
      fn character -> %{character | education: character.education + 1} end,
      increment_skill(:brawling),
    ] |> Enum.random()
  end

  @impl TravellerEx.Profession
  def service_skills(%TravellerEx.Character{}) do
    [
      increment_skill(:vehicle),
      increment_skill(:air_raft),
      increment_skill(:gun_combat),
      increment_skill(:fwd_observer),
      increment_skill(:blade_combat),
      increment_skill(:gun_combat),
    ]
    |> Enum.random()
  end

  @impl TravellerEx.Profession
  def advanced_education(%TravellerEx.Character{education: education}) when education >= 8 do
    [
      increment_skill(:vehicle),
      increment_skill(:tactics),
      increment_skill(:tactics),
      increment_skill(:computer),
      increment_skill(:leader),
      increment_skill(:admin),
    ]
    |> Enum.random()
  end

  def advanced_education(%TravellerEx.Character{}) do
    [
      increment_skill(:vehicle),
      increment_skill(:mechanical),
      increment_skill(:electronic),
      increment_skill(:tactics),
      increment_skill(:blade_combat),
      increment_skill(:gun_combat),
    ]
    |> Enum.random()
  end

  @impl TravellerEx.Profession
  def base_skills(character = %TravellerEx.Character{}) do
    increment_skill(:rifle).(character)
  end

  @impl TravellerEx.Profession
  def promotion_skills(character, nil, 1) do
    increment_skill(:smg).(character)
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
      add_item(:gun),
      add_item(:high_passage),
      add_item(:middle_passage),
      increment_attribute(:social_standing, 1),
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
      2_000,
      5_000,
      10_000,
      10_000,
      10_000,
      20_000,
      30_000
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
      1 -> "Lietenant"
      2 -> "Captain"
      3 -> "Major"
      4 -> "Lt Colonel"
      5 -> "Colonel"
      6 -> "General"
      _ -> "Private"
    end
  end
end
