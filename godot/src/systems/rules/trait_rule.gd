class_name TraitRule extends Rule

@export var target: Character.Trait
@export var allowed_values: Array
@export var forbidden_values: Array


func get_allowed_values() -> Array:
	if allowed_values.is_empty():
		allowed_values = Globals.character_generator.get_trait_values(target)
		for value in forbidden_values:
			allowed_values.erase(value)
			
	return allowed_values
	

func get_forbidden_values() -> Array:
	if forbidden_values.is_empty():
		forbidden_values = Globals.character_generator.get_trait_values(target)
		for value in allowed_values:
			forbidden_values.erase(value)
			
	return forbidden_values
	

func is_met_by(character: Character) -> bool:
	var value = character.get_trait(target)
	return get_allowed_values().has(value)
	

func make_character_meet(character: Character) -> void:
	character.set_trait(target, get_allowed_values().pick_random())
	

func make_character_not_meet(character: Character) -> void:
	character.set_trait(target, get_forbidden_values().pick_random())
