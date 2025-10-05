class_name Passport extends MarginContainer

@export var ClaimScene: PackedScene

@export var religion_icons: Array[Texture2D]
@export var stamp_textures: Array[Texture2D]


var character: Character:
	set(value):
		character = value
		if is_node_ready():
			_setup()
	

var stamping: bool = false

@onready var stamp_sfx: AudioStreamPlayer = %StampSfx
@onready var stamp: Sprite2D = %Stamp

func _ready() -> void:
	assert(religion_icons.size() == Globals.character_generator.religions.size())
	
	if character != null:
		_setup()
	
	hide()
	Events.show_passport_requested.connect(show)
	Events.day_finished.connect(close)
	Events.stamp_requested.connect(_on_stamp_requested)
	Events.character_entered.connect(func(x): character = x)
	

func close() -> void:
	hide()
	
	# TODO: close dialog?
	
	
func _input(event: InputEvent):
	if not visible:
		return
	
	if event.is_action_released("ui_cancel"):
		get_viewport().set_input_as_handled()
		close()
	

func _setup() -> void:
	stamp.hide()
	
	%ReligionIcon.texture = religion_icons[character.religion - 1]
	%Religion.text = Globals.religion_names[character.religion - 1]
	
	%Name.text = character.name
	%Gender.text = Character.Gender.keys()[character.gender].to_lower()
	%CharacterPortrait.character = character
	
	for child in %ClaimsContainer.get_children():
		child.queue_free()
	
	for claim in character.claims:
		_create_claim(claim)
	

func _create_claim(claim: Claim) -> void:
	var scene = ClaimScene.instantiate()
	scene.claim = claim
	%ClaimsContainer.add_child(scene)
	

func _on_stamp_requested(destination: Types.Destination) -> void:
	if character == null:
		return
	
	if stamping:
		return
	
	stamping = true
	GSLogger.info("Stamped character with %s (expected: %s)" % [
		Types.Destination.keys()[destination],
		Types.Destination.keys()[character.destination],
	])
	
	if not visible:
		show()
		await get_tree().create_timer(0.3).timeout
	
	stamp.position = Vector2(randi_range(-50, 25), randi_range(-50, 20))
	stamp.texture = stamp_textures[destination]
	
	await get_tree().create_timer(0.2).timeout
	stamp_sfx.play()
	await get_tree().create_timer(0.3).timeout
	stamp.show()
	await get_tree().create_timer(2.0).timeout
	close()
	
	Events.character_stamped.emit(destination, character.destination)
	stamping = false
	
