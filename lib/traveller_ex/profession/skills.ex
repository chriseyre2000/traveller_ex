defmodule TravellerEx.Profession.Skills do
  def increment_skill(skill) do
    fn character -> %TravellerEx.Character{character | skills: character.skills |> Map.update(skill, 1, &(&1 + 1))} end
  end

   @spec increment_attribute(any, any) :: (TravellerEx.Character.t() -> TravellerEx.Character.t())
   def increment_attribute(attribute, quantity \\ 1) do
    fn character = %TravellerEx.Character{} -> character |> Map.update(attribute, 0, &(&1 + quantity)) end
  end

  def add_item(item) do
    fn character = %TravellerEx.Character{} ->
      possessions = [item | character.possessions]
      %TravellerEx.Character{character | possessions: possessions}
    end
  end
end
