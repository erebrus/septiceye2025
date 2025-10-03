extends MarginContainer

var character: Character:
	set(value):
		character = value
		if is_node_ready():
			_setup()
	

func _ready() -> void:
	if character != null:
		_setup()
	

func _setup() -> void:
	%Label.text = character.name
