class_name Rule extends Resource

@export var religion: Types.Religion

@export var description: String

@export var met_destinations: Array[Types.Destination]
@export var unmet_destinations: Array[Types.Destination]

func _init() -> void:
	met_destinations.assign(Types.Destination.values())
	unmet_destinations.assign(Types.Destination.values())
	

func is_met_by(character: Character) -> bool:
	return true
	

func should_apply(character: Character) -> bool:
	return religion == Types.Religion.UNKNOWN or religion == character.religion
	

func make_character_meet(_character: Character) -> void:
	pass
	

func make_character_not_meet(_character: Character) -> void:
	pass
	
