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
	%Name.text = character.name
	%Gender.text = Character.Gender.keys()[character.gender].to_lower()
	%Religion.text = Types.Religion.keys()[Types.Religion].to_lower()
	
