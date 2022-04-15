defmodule TravellerEx.Profession.Army do
  @behaviour TravellerEx.Profession

  @impl TravellerEx.Profession
  @spec enlist_threshold(TravellerEx.Character.t()) :: 2 | 3 | 4 | 5
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
  @spec survive_threshold(TravellerEx.Character.t()) :: 3 | 5
  def survive_threshold(%TravellerEx.Character{} = character) do
    value = 5
    if character.education >= 6 do
      value - 2
    else
      value
    end
  end

  @impl TravellerEx.Profession
  @spec commission_threshold(atom | %{endurance: any}) :: 4 | 5
  def commission_threshold(%TravellerEx.Character{} = character) do
    value = 5
    if (character.endurance >= 7) do
      value - 1
    else
      value
    end
  end



end
