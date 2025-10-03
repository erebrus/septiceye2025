class_name ScheduledDeathsRule extends Rule

func _init() -> void:
	description = "Souls should be scheduled to pass on today to access the afterlife realms."
	met_destinations = [Types.Destination.RETURN]
	unmet_destinations.assign(Types.Destination.values().filter(func(x): return x != Types.Destination.RETURN))
	

func is_met_by(character: Character) -> bool:
	return not character.is_in_list
	

func make_character_meet(character: Character) -> void:
	character.is_in_list = false
	

func make_character_not_meet(character: Character) -> void:
	character.is_in_list = true
