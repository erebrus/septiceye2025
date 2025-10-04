class_name ScheduledDeaths extends PopupPanel

@export var NameScene: PackedScene

@onready var container: GridContainer = %NameContainer


func _ready() -> void:
	assert(NameScene != null)
	hide()
	Events.show_list_requested.connect(func(): popup())
	

func set_state(state: GameState):
	for child in container.get_children():
		child.queue_free()
	
	var queue := state.character_queue.duplicate()
	queue.shuffle()
	
	if queue.size() > 16:
		container.columns = 2
	else:
		container.columns = 1
	for character in queue:
		if character.is_in_list:
			var character_name = NameScene.instantiate()
			character_name.character = character
			container.add_child(character_name)
	
