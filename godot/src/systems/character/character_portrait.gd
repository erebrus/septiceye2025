class_name CharacterPortrait extends Node2D


var character: Character:
	set(value):
		character = value
		if is_node_ready():
			_setup()
	

@onready var generator: CharacterGenerator = Globals.character_generator

@onready var torso: Sprite2D = %Torso

@onready var head: Sprite2D = %Head
@onready var eyes: Sprite2D = %Eyes

@onready var hair_back: Sprite2D = %HairBack
@onready var hair_front: Sprite2D = %HairFront

func _ready() -> void:
	if character != null:
		_setup()
	
	Events.character_entered.connect(func(x): character = x)
	

func _set_skin_color(color: Color) -> void:
	head.modulate = color
	eyes.modulate = color
	

func _set_hair_color(color: Color) -> void:
	hair_back.modulate = color
	hair_front.modulate = color
	

func _setup() -> void:
	if character.torso_config == null:
		return
	%BehindTorso.position = character.torso_config.head_position
	%InFrontOfTorso.position = character.torso_config.head_position
	
	_set_skin_color(character.skin_color_code)
	_set_hair_color(character.hair_color_code)
	
	_set_sprite(torso, character.torso_config.texture)
	_set_sprite(head, character.head_config.texture)
	_set_sprite(hair_back, character.hair_config.texture)
	_set_sprite(hair_front, character.hair_config.front_texture)
	

func _set_sprite(sprite: Sprite2D, texture: Texture2D) -> void:
	if texture != null:
		sprite.visible = true
		sprite.texture = texture
	else:
		sprite.visible = false
	
