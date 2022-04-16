defmodule TravellerEx.Profession.Skills do
  def increment_skill(skill) do
    fn character -> %TravellerEx.Character{character | skills: character.skills |> Map.update(skill, 1, &(&1 + 1))} end
  end

  @spec increment_attribute(any) :: (TravellerEx.Character.t() -> TravellerEx.Character.t())
  def increment_attribute(attribute) do
    fn character = %TravellerEx.Character{} -> character |> Map.update(attribute, 0, &(&1 + 1)) end
  end
end
