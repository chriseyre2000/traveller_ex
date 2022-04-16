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

  def generate(target_terms, _prefered_service) do
    character = TravellerEx.Character.random()

    profession = TravellerEx.Profession.Army

    enlist(character, profession)
    |> case do
      :ok -> IO.puts "In the army now"
      :failed -> IO.puts "To the draft, army for now"
    end

    {character, _} = Stream.cycle([1])
      |> Enum.reduce_while({character, target_terms}, fn _term, {character, remaining_terms} ->
        if survive(character, profession) == :died do
          throw "You are dead"
        else
          IO.puts "You lived"
        end

        character = if (character.age == 18) do
          IO.puts "Initial 2 skills"
          character = add_skill(character, profession)
          add_skill(character, profession)
        else
          add_skill(character, profession)
        end

        character = if character.rank == nil do
          if gain_commission(character, profession) == :ok do
            IO.puts "Initial commission"
            character = character |> Map.put(:rank, 1)
            add_skill(character, profession)
          else
            character
          end
        else
          character
        end

        character = if character.rank != nil do
          if gain_promotion(character, profession) == :ok do
            IO.puts "Promoted"
            character = character |> Map.update!(:rank, & (&1 + 1))
            add_skill(character, profession)
          else
            character
          end
        else
          character
        end

        character = %TravellerEx.Character{character | age: character.age + 4}

        # Apply aging rules

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
