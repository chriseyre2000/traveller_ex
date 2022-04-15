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

  def gain_promotion(character = %TravellerEx.Character{}, profession) do
    threshold = profession.promotion_threshold(character)
    if TravellerEx.dice(2) >= threshold do
      :ok
    else
      :failed
    end
  end

  def reenlist(character = %TravellerEx.Character{}, profession) do
    threshold = profession.reenlist_threshold(character)
    roll = TravellerEx.dice(2)
    cond do
      roll == 12 -> :madantory_reenlist
      roll >= threshold -> :may_reenlist
      true -> :muster_out
    end
  end
end
