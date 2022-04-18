defmodule TravellerEx.Profession.Scouts do
  @behaviour TravellerEx.Profession
  import TravellerEx.Profession.Skills

  @impl TravellerEx.Profession
  def enlist_threshold(%TravellerEx.Character{} = character) do
    value = 7
    value = if character.intelligence >= 6 do
      value - 1
    else
      value
    end
    if character.strength >= 8 do
      value - 2
    else
      value
    end
  end

  @impl TravellerEx.Profession
  def survive_threshold(%TravellerEx.Character{} = character) do
    value = 7
    if character.endurance >= 9 do
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
    3
  end

  @impl TravellerEx.Profession
  def personal_development(%TravellerEx.Character{}) do
    [
      increment_attribute(:strength),
      increment_attribute(:dexterity),
      increment_attribute(:endurance),
      increment_attribute(:intelligence),
      increment_attribute(:education),
      increment_skill(:gun_combat),
    ] |> Enum.random()
  end

  @impl TravellerEx.Profession
  def service_skills(%TravellerEx.Character{}) do
    [
      increment_skill(:vehicle),
      increment_skill(:vacc_suit),
      increment_skill(:mechanical),
      increment_skill(:navigation),
      increment_skill(:electronics),
      increment_skill(:jack_o_t),
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
      increment_skill(:jack_o_t),
    ]
    |> Enum.random()
  end

  def advanced_education(%TravellerEx.Character{}) do
    [
      increment_skill(:vehicle),
      increment_skill(:mechanical),
      increment_skill(:electronic),
      increment_skill(:jack_o_t),
      increment_skill(:gunnery),
      increment_skill(:medical),
    ]
    |> Enum.random()
  end

  @impl TravellerEx.Profession
  def base_skills(character = %TravellerEx.Character{}) do
    increment_skill(:pilot).(character)
  end

  @impl TravellerEx.Profession
  def promotion_skills(character, _from, _to) do
    character
  end

  @impl TravellerEx.Profession
  def benefits(character = %TravellerEx.Character{}) do
    benefit_list = [
      add_item(:low_passage),
      increment_attribute(:intelligence, 2),
      increment_attribute(:education, 2),
      add_item(:blade),
      add_item(:gun),
      add_item(:scout_ship),
    ]

    bonus = benefit_list
    |> Enum.random()

    bonus.(character)
  end

  @impl TravellerEx.Profession
  def cash_benefits(character = %TravellerEx.Character{}) do
    amounts = [
      20_000,
      20_000,
      30_000,
      30_000,
      50_000,
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

  def rank(%TravellerEx.Character{}) do
    ""
  end
end
