defmodule TravellerEx.Profession.Merchants do
  @behaviour TravellerEx.Profession
  import TravellerEx.Profession.Skills

  @impl TravellerEx.Profession
  def enlist_threshold(%TravellerEx.Character{} = character) do
    value = 7
    value = if character.strength >= 7 do
      value - 1
    else
      value
    end
    if character.intelligence >= 6 do
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
    value = 4
    if (character.intelligence >= 6) do
      value - 1
    else
      value
    end
  end

  @impl TravellerEx.Profession
  def promotion_threshold(%TravellerEx.Character{} = character) do
    value = 10
    if character.intelligence >= 9 do
      value - 1
    else
      value
    end
  end

  @impl TravellerEx.Profession
  def reenlist_threshold(%TravellerEx.Character{}) do
    4
  end

  @impl TravellerEx.Profession
  def personal_development(%TravellerEx.Character{}) do
    [
      increment_attribute(:strength),
      increment_attribute(:dexterity),
      increment_attribute(:endurance),
      increment_attribute(:strength),
      increment_skill(:blade_combat),
      increment_skill(:bribery),
    ] |> Enum.random()
  end

  @impl TravellerEx.Profession
  def service_skills(%TravellerEx.Character{}) do
    [
      increment_skill(:vehicle),
      increment_skill(:vacc_suit),
      increment_skill(:jack_o_t),
      increment_skill(:steward),
      increment_skill(:electronics),
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
      increment_skill(:streetwise),
      increment_skill(:mechanical),
      increment_skill(:electronic),
      increment_skill(:navigation),
      increment_skill(:gunnery),
      increment_skill(:medical),
    ]
    |> Enum.random()
  end

  @impl TravellerEx.Profession
  def base_skills(character = %TravellerEx.Character{}) do
    character
  end

  @impl TravellerEx.Profession
  @spec promotion_skills(any, any, any) :: any
  def promotion_skills(character, 3, 4) do
    increment_skill(:pilot).(character)
  end
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
      add_item(:blade),
      add_item(:low_passage),
      add_item(:free_traider),
    ]

    bonus = if character.rank != nil && character.rank > 4 do
      benefit_list |> Enum.drop(1)
    else
      benefit_list |> Enum.take(6)
    end
    |> Enum.random()

    bonus.(character)
  end

  @impl TravellerEx.Profession
  def cash_benefits(character = %TravellerEx.Character{}) do
    amounts = [
      1_000,
      5_000,
      10_000,
      20_000,
      20_000,
      40_000,
      40_000
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
      1 -> "4th Officer"
      2 -> "3rd Officer"
      3 -> "2nd Officer"
      4 -> "1st Officer"
      5 -> "Captain"
      6 -> "Captain"
      _ -> "Enlisted"
    end
  end
end
