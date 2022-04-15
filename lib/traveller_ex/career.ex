defmodule TravellerEx.Career do
  @spec enlist(TravellerEx.Character.t(), atom) :: :failed | :ok
  def enlist(character = %TravellerEx.Character{}, profession) do
    threshold = profession.enlist_threshold(character)
    if TravellerEx.dice(2) >= threshold do
      :ok
    else
      :failed
    end
  end

  @spec survive(TravellerEx.Character.t(), atom) :: :died | :ok
  def survive(character = %TravellerEx.Character{}, profession) do
    threshold = profession.survive_threshold(character)
    if TravellerEx.dice(2) >= threshold do
      :ok
    else
      :died
    end
  end

  def gain_commission(character = %TravellerEx.Character{}, profession) do
    threshold = profession.commission_threshold(character)
    if TravellerEx.dice(2) >= threshold do
      :ok
    else
      :failed
    end
  end
end
