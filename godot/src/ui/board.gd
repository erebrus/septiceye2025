class_name Board extends Control

var tallyMap:Dictionary[Types.Destination, TallyLine]
@onready var total_tally: TallyLine = $TextureRect/MarginContainer/VBoxContainer/TotalTally

func _ready():
	tallyMap = {
		Types.Destination.RETURN:$TextureRect/MarginContainer/VBoxContainer/ReturnTally,
		Types.Destination.HEAVEN:$TextureRect/MarginContainer/VBoxContainer/HeavenTally,
		Types.Destination.REINCARNATE:$TextureRect/MarginContainer/VBoxContainer/ReincarnationTally,
		Types.Destination.PURGATORY:$TextureRect/MarginContainer/VBoxContainer/PurgatoryTally,
		Types.Destination.HELL:$TextureRect/MarginContainer/VBoxContainer/HellTally,				
	}
	Events.pre_day_started.connect(_on_pre_day_started)
	Events.character_stamped.connect(_on_character_stamped)
	
	

func _on_pre_day_started(quotas:Dictionary[Types.Destination, int], extra_souls:int, ruleset: RuleSet):
	for tally in tallyMap.values():
		tally.reset()
	total_tally.reset()
	var sum:=0
	for dest in tallyMap.keys():
		if dest in quotas:
			tallyMap[dest].expected = quotas[dest]
			sum += quotas[dest]
		else:
			tallyMap[dest].expected = 0
	total_tally.expected = sum + extra_souls

func _on_character_stamped(destination: Types.Destination, expected: Types.Destination):
	tallyMap[destination].add()
	total_tally.add()
