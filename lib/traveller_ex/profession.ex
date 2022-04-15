defprotocol TravellerEx.Profession do
  @spec enlist_threshold(TravellerEx.Character.t()) :: pos_integer()
  def enlist_threshold(character)

  @spec survive_threshold(TravellerEx.Character.t()) :: pos_integer()
  def survive_threshold(character)

  @spec commission_threshold(TravellerEx.Character.t()) :: pos_integer()
  def commission_threshold(character)

end

