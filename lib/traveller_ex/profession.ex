defprotocol TravellerEx.Profession do
  @spec enlist_threshold(TravellerEx.Character.t()) :: pos_integer()
  def enlist_threshold(character)

  @spec survive_threshold(TravellerEx.Character.t()) :: pos_integer()
  def survive_threshold(character)

  @spec commission_threshold(TravellerEx.Character.t()) :: pos_integer()
  def commission_threshold(character)

  @spec promotion_threshold(TravellerEx.Character.t()) :: pos_integer()
  def promotion_threshold(character)

  @spec reenlist_threshold(TravellerEx.Character.t()) :: pos_integer()
  def reenlist_threshold(character)

  @spec personal_development(TravellerEx.Character.t()) :: (TravellerEx.Character.t() -> TravellerEx.Character.t())
  def personal_development(character)

  @spec service_skills(TravellerEx.Character.t()) :: (TravellerEx.Character.t() -> TravellerEx.Character.t())
  def service_skills(character)

  @spec advanced_education(TravellerEx.Character.t()) :: (TravellerEx.Character.t() -> TravellerEx.Character.t())
  def advanced_education(character)

end

