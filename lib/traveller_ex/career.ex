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
  def generate(target_terms, _prefered_service) do
    character = TravellerEx.Character.random()

    profession = TravellerEx.Profession.Army

    enlist(character, profession)
    |> case do
      :ok -> IO.puts "In the army now"
      :failed -> IO.puts "To the draft, army for now"
    end

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

        # Special skills at end of term

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
        |> Map.update!(:rank, & (&1 + 1))
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
end
