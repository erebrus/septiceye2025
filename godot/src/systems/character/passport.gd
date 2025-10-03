class_name Passport extends PopupPanel

var character: Character:
	set(value):
		character = value
		if is_node_ready():
			_setup()
	

func _ready() -> void:
	if character != null:
		_setup()
	
	Events.show_passport_requested.connect(popup)
	Events.stamp_requested.connect(_on_stamp_requested)
	Events.character_entered.connect(func(x): character = x)
	

func _setup() -> void:
	%Name.text = character.name
	%Gender.text = Character.Gender.keys()[character.gender].to_lower()
	%Religion.text = Types.Religion.keys()[character.religion].to_lower()
	

func _on_stamp_requested(destination: Types.Destination) -> void:
	# TODO open passport and stamp it 
	GSLogger.info("Stamped character with %s (expected: %s)" % [
		Types.Destination.keys()[destination],
		Types.Destination.keys()[character.destination],
	])
	Events.character_stamped.emit(destination, character.destination)
	
