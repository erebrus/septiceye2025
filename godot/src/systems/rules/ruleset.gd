class_name RuleSet extends Resource

@export var rules: Array[Rule]

static var destinations: Array[Types.Destination]

static func _init() -> void:
	destinations.assign(Types.Destination.values())
	
func possible_fates_for(character: Character) -> Array[Types.Destination]:
	#TODO review that it can fit all types of rules
	var possible_destinations:Array[Types.Destination] = []
	var rejected_destinations:Array[Types.Destination] = []
	#For all applicable rules, add the possible and forbidden destinations
	for rule in rules:
		if not rule.should_apply(character):
			continue
		var dest:Types.Destination = rule.met_destinations[0]
		if rule.is_met_by(character):
			if not dest in possible_destinations:
				possible_destinations.append(dest) 
		elif not rule.description.begins_with("All"):
			if not dest in rejected_destinations:
				rejected_destinations.append(dest)
	#Remove the forbidden destinations from the possible ones
	possible_destinations = possible_destinations.filter(func(x): return not x in rejected_destinations)
	assert(not possible_destinations.is_empty())

	return possible_destinations
	

func expected_fate_for(character: Character) -> Types.Destination:
	var possible = possible_fates_for(character)
	if possible.size() == 1:
		GSLogger.info("Character with destination: %s" % Types.Destination.keys()[possible.front()])
	else:
		GSLogger.warn("Character with multiple destinations (chosen: %s)" % Types.Destination.keys()[possible.front()])
	
	return possible.front()
	

func _filter_destinations(source: Array[Types.Destination], allowed: Array[Types.Destination]) ->  Array[Types.Destination]:
	var target: Array[Types.Destination]
	for destination in source:
		if allowed.has(destination):
			target.append(destination)
	return target
