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
	Events.character_stamped.connect(_on_character_stamped)
	await get_tree().process_frame
	for tally in tallyMap.values():
		tally.reset()
	total_tally.reset()

func _on_character_stamped(destination: Types.Destination, expected: Types.Destination):
	tallyMap[destination].add()
	total_tally.add()
