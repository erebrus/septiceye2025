class_name Passport extends MarginContainer

@export var ClaimScene: PackedScene


var character: Character:
	set(value):
		character = value
		if is_node_ready():
			_setup()
	

func _ready() -> void:
	if character != null:
		_setup()
	
	hide()
	Events.show_passport_requested.connect(show)
	Events.stamp_requested.connect(_on_stamp_requested)
	Events.character_entered.connect(func(x): character = x)
	

func _setup() -> void:
	%Name.text = character.name
	%Gender.text = Character.Gender.keys()[character.gender].to_lower()
	%Religion.text = Types.Religion.keys()[character.religion].to_lower()
	
	for claim in character.claims:
		_create_claim(claim)

func _create_claim(claim: Claim) -> void:
	var scene = ClaimScene.instantiate()
	scene.claim = claim
	%ClaimsContainer.add_child(scene)
	

func _on_stamp_requested(destination: Types.Destination) -> void:
	# TODO open passport and stamp it 
	GSLogger.info("Stamped character with %s (expected: %s)" % [
		Types.Destination.keys()[destination],
		Types.Destination.keys()[character.destination],
	])
	Events.character_stamped.emit(destination, character.destination)
	
