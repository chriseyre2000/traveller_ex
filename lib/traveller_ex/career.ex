defmodule TravellerEx.Career do

  @profession_map %{
    army: TravellerEx.Profession.Army,
    navy: TravellerEx.Profession.Navy,
  }

  @spec enlist(TravellerEx.Character.t(), atom) :: :draft | :ok
  def enlist(character = %TravellerEx.Character{}, profession) do
    threshold = profession.enlist_threshold(character)
    if TravellerEx.dice(2) >= threshold do
      :ok
    else
      :draft
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

  @spec gain_commission(TravellerEx.Character.t(), atom) :: :failed | :ok
  def gain_commission(character = %TravellerEx.Character{}, profession) do
    threshold = profession.commission_threshold(character)
    if TravellerEx.dice(2) >= threshold do
      :ok
    else
      :failed
    end
  end

  @spec gain_promotion(TravellerEx.Character.t(), atom) :: :failed | :ok
  def gain_promotion(character = %TravellerEx.Character{}, profession) do
    threshold = profession.promotion_threshold(character)
    if TravellerEx.dice(2) >= threshold do
      :ok
    else
      :failed
    end
  end

  @spec reenlist(TravellerEx.Character.t(), atom) ::
          :madantory_reenlist | :may_reenlist | :muster_out
  def reenlist(character = %TravellerEx.Character{}, profession) do
    threshold = profession.reenlist_threshold(character)
    roll = TravellerEx.dice(2)
    cond do
      roll == 12 -> :madantory_reenlist
      roll >= threshold -> :may_reenlist
      true -> :muster_out
    end
  end

  @spec generate(any, any) :: any
  def generate(target_terms, prefered_service) do
    character = TravellerEx.Character.random()

    profession = @profession_map |> Map.get(prefered_service)

    character = if :ok == enlist(character, profession) do
      character |> Map.replace(:profession, prefered_service)
    else
      character |> Map.replace(:profession, [:army, :navy] |> Enum.random())
    end

    profession = @profession_map |> Map.get(character.profession)

    character = character
      |> profession.base_skills()

    {character, _} = Stream.cycle([1])
      |> Enum.reduce_while({character, target_terms}, fn _term, {character, remaining_terms} ->
        if survive(character, profession) == :died do
          throw "You are dead"
        end

        character = character
          |> training(profession)
          |> commission(profession)
          |> promotion(profession)
          |> increase_age()
          |> aging()

        reenlist(character, profession)
        |> case do
          :madantory_reenlist -> {:cont, {character, remaining_terms}}
          :may_reenlist ->
            if target_terms == 1 do
              {:halt, {character, 0}}
              else
            {:cont, {character, remaining_terms - 1}}
              end
          :muster_out -> {:halt, {character, 0}}
        end
      end)

    # benefits
    num = number_of_benefits(character)

    {character, _} = Enum.reduce(1..num, {character, 0}, fn _, {character, times_cash_taken} ->

      benefit_type = if times_cash_taken == 3 do
        :benefit
      else
        [:benefit, :cash] |> Enum.random()
      end

      times_cash_taken = if benefit_type == :cash, do: times_cash_taken + 1, else: times_cash_taken

      character = if benefit_type == :cash do
        profession.cash_benefits(character)
      else
        profession.benefits(character)
      end

      {character, times_cash_taken}
    end)

    character
  end

  defp training(character, profession) do
    if (character.age == 18) do
      character = add_skill(character, profession)
      add_skill(character, profession)
    else
      add_skill(character, profession)
    end
  end

  defp commission(character, profession) do
    if character.rank == nil do
      if gain_commission(character, profession) == :ok do
        character = character |> Map.put(:rank, 1)
        add_skill(character, profession)
      else
        character
      end
    else
      character
    end
  end

  defp promotion(character, profession) do
    prev_rank = character.rank
    if character.rank != nil do
      if gain_promotion(character, profession) == :ok do
        character
        |> Map.update!(:rank, fn
          6 -> 6
          rank -> rank + 1
        end)
        |> profession.promotion_skills(prev_rank, character.rank)
        |> add_skill(profession)
      else
        character
      end
    else
      character
    end
  end

  defp increase_age(character = %TravellerEx.Character{}) do
    %TravellerEx.Character{character | age: character.age + 4}
  end

  defp aging(character = %TravellerEx.Character{age: age}) when age < 34 do
    character
  end

  defp aging(character = %TravellerEx.Character{age: age}) when age < 50 do
    character
    |> possibly_reduce(:strength, 1, 8)
    |> possibly_reduce(:dexterity, 1, 7)
    |> possibly_reduce(:endurance, 1, 8)
  end

  defp aging(character = %TravellerEx.Character{age: age}) when age < 66 do
    character
    |> possibly_reduce(:strength, 1, 9)
    |> possibly_reduce(:dexterity, 1, 8)
    |> possibly_reduce(:endurance, 1, 9)
  end

  defp aging(character = %TravellerEx.Character{}) do
    character
    |> possibly_reduce(:strength, 2, 9)
    |> possibly_reduce(:dexterity, 2, 8)
    |> possibly_reduce(:endurance, 2, 9)
    |> possibly_reduce(:intelligence, 1, 9)
  end

  defp possibly_reduce(character = %TravellerEx.Character{}, attribute, amount, save) do
    if TravellerEx.dice(2) >= save do
      character
    else
      character |> Map.update(attribute, 0, &(&1 - amount))
    end
  end

  @spec add_skill(TravellerEx.Character.t(), atom) :: TravellerEx.Character.t()
  def add_skill(character= %TravellerEx.Character{}, profession) do
    skill = [
      profession.personal_development(character),
      profession.service_skills(character),
      profession.advanced_education(character)
    ] |> Enum.random()
    skill.(character)
  end

  defp number_of_benefits(character= %TravellerEx.Character{}) do
    terms = div(character.age - 18, 4)
    rank_bonus = case character.rank do
      1 -> 1
      2 -> 1
      3 -> 2
      4 -> 2
      5 -> 3
      6 -> 3
      _ -> 0
    end

    terms + rank_bonus
  end
end
