class_name Passport extends Control

@export var ClaimScene: PackedScene

@export var religion_icons: Array[Texture2D]
@export var stamp_textures: Array[Texture2D]

@export var talk_speed: float = 200.0

var character: Character:
	set(value):
		character = value
		if is_node_ready():
			_setup()
	

var stamping: bool = false

var male_babble_sfx: Array[AudioStreamPlayer]
var female_babble_sfx: Array[AudioStreamPlayer]
var character_sfx: AudioStreamPlayer

var talk_tween: Tween
var is_talking: bool = false

@onready var stamp_sfx: AudioStreamPlayer = %StampSfx
@onready var stamp: Sprite2D = %Stamp
@onready var dialog: Control = %Dialog
@onready var follow_up: Label = %FollowUpLabel


func _ready() -> void:
	assert(religion_icons.size() == Globals.character_generator.religions.size())
	
	male_babble_sfx.append(%LowBabbleSfx)
	male_babble_sfx.append(%MidBabbleSfx)
	
	female_babble_sfx.append(%MidBabbleSfx)
	female_babble_sfx.append(%LowBabbleSfx)
	
	if character != null:
		_setup()
	
	close()
	
	Events.show_passport_requested.connect(show)
	Events.day_finished.connect(close)
	Events.stamp_requested.connect(_on_stamp_requested)
	Events.character_entered.connect(func(x): character = x)
	

func close() -> void:
	hide()
	dialog.hide()
	

func _input(event: InputEvent):
	if not visible:
		return
	
	if event.is_action_released("ui_cancel"):
		get_viewport().set_input_as_handled()
		close()
	

func _setup() -> void:
	stamp.hide()
	
	if character.gender == Character.Gender.MALE:
		character_sfx = male_babble_sfx.pick_random()
	else:
		character_sfx = female_babble_sfx.pick_random()
	
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
	scene.claim_selected.connect(_on_claim_selected)
	%ClaimsContainer.add_child(scene)
	

func _start_talking() -> void:
	if talk_tween:
		talk_tween.kill()
	
	is_talking = true
	character_sfx.play()
	
	var num_characters = follow_up.text.length()
	talk_tween = create_tween()
	talk_tween.tween_property(follow_up, "visible_characters", num_characters, num_characters / talk_speed)
	
	#talk_tween.play()
	
	await talk_tween.finished
	
	is_talking = false
	character_sfx.stop()
	

func _on_claim_selected(claim: Claim) -> void:
	follow_up.text = claim.follow_up
	follow_up.visible_characters = 0
	
	dialog.show()
	_start_talking()
	

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
	


func _on_babble_sfx_finished():
	if not is_talking:
		return
	
	await get_tree().create_timer(randf_range(0.05, 0.2)).timeout
	
	if is_talking:
		character_sfx.play()
