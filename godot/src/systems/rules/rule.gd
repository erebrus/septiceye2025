class_name Rule extends Resource

@export var short_name:String 
@export var religion: Types.Religion
@export var description: String

@export var start_day:int = 0
@export var end_day:int = 100

@export var met_destinations: Array[Types.Destination]
@export var unmet_destinations: Array[Types.Destination]

@export var priority:=1


func is_met_by(_character: Character) -> bool:	
	return true
	

func should_apply(character: Character) -> bool:
	return religion == Types.Religion.UNKNOWN or religion == character.religion
	

func make_character_meet(_character: Character) -> void:
	pass
	

func make_character_not_meet(_character: Character) -> void:
	pass
	
