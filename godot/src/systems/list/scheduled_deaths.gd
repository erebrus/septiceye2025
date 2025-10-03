class_name ScheduledDeaths extends PopupPanel

@export var NameScene: PackedScene

@onready var container: Container = %NameContainer


func _ready() -> void:
	assert(NameScene != null)
	hide()
	Events.show_list_requested.connect(func(): popup())
	

func set_state(state: GameState):
	for child in container.get_children():
		child.queue_free()
	
	for character in state.character_queue:
		if character.is_in_list:
			var character_name = NameScene.instantiate()
			character_name.character = character
			container.add_child(character_name)
	
