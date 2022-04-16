defmodule TravellerEx.Character do

  @type t :: %__MODULE__{
    strength: integer,
    dexterity: integer,
    endurance: integer,
    intelligence: integer,
    education: integer,
    social_standing: integer,
    rank: nil | integer
  }

  defstruct strength: 7,
            dexterity: 7,
            endurance: 7,
            intelligence: 7,
            education: 7,
            social_standing: 7,
            age: 18,
            rank: nil,
            skills: %{}

  @spec new :: TravellerEx.Character.t()
  def new do
    %__MODULE__{age: 18, skills: %{}}
  end

  @spec random :: TravellerEx.Character.t()
  def random do
    TravellerEx.universal_personality_profile() |> from_upp()
  end

  @spec from_upp(binary) :: TravellerEx.Character.t()
  def from_upp(upp) when is_binary(upp) do
    [str, dex, endu, int, edu, ss] = String.split(upp, "", trim: true) |> Enum.map(&convert/1)

    %__MODULE__{
      new()
      | strength: str,
        dexterity: dex,
        endurance: endu,
        intelligence: int,
        education: edu,
        social_standing: ss
    }
  end

  @spec to_upp(TravellerEx.Character.t()) :: binary
  def to_upp(
        %__MODULE__{
          strength: str,
          dexterity: dex,
          endurance: endu,
          intelligence: int,
          education: edu,
          social_standing: ss
        }
      ) do
        [str, dex, endu, int, edu, ss] |> Enum.map(&TravellerEx.hex_encode/1) |> Enum.join()
  end

  defp convert("A"), do: 10
  defp convert("B"), do: 11
  defp convert("C"), do: 12
  defp convert("D"), do: 13
  defp convert("E"), do: 14
  defp convert("F"), do: 15

  defp convert(digit) do
    {number, ""} = Integer.parse(digit)
    number
  end
end
