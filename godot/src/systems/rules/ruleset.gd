class_name RuleSet extends Resource

@export var rules: Array[Rule]

static var destinations: Array[Types.Destination]

static func _init() -> void:
	destinations.assign(Types.Destination.values())
	

func expected_fate_for(character: Character) -> Types.Destination:
	var possible_destinations = destinations
	for rule in rules:
		if not rule.should_apply(character):
			continue
		
		if rule.is_met_by(character):
			possible_destinations = _filter_destinations(possible_destinations, rule.met_destinations)
		else:
			possible_destinations = _filter_destinations(possible_destinations, rule.unmet_destinations)
		
		assert(not possible_destinations.is_empty())
		
		if possible_destinations.size() == 1:
			return possible_destinations.front()
	
	GSLogger.warn("Character with multiple possible destinations")
	return possible_destinations.front()
	

func _filter_destinations(source: Array[Types.Destination], allowed: Array[Types.Destination]) ->  Array[Types.Destination]:
	var target: Array[Types.Destination]
	for destination in source:
		if allowed.has(destination):
			target.append(destination)
	return target
