class_name CharacterPortrait extends Node2D

@export var skin_material: ShaderMaterial
@export var hair_material: ShaderMaterial


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
	head.material = skin_material
	eyes.material = skin_material
	
	hair_back.material = hair_material
	hair_front.material = hair_material
	
	if character != null:
		_setup()
	

func _set_skin_color(color: Color) -> void:
	skin_material.set_shader_parameter("target_color", color)
	#%Head.modulate = color
	#%Eyes.modulate = color
	

func _set_hair_color(color: Color) -> void:
	hair_material.set_shader_parameter("target_color", color)
	#%HairBack.modulate = color
	#%HairFront.modulate = color
	

func _setup() -> void:
	if character.torso_config == null:
		return
	%BehindTorso.position = character.torso_config.head_position
	%InFrontOfTorso.position = character.torso_config.head_position
	
	_set_skin_color(character.skin_color_code)
	_set_hair_color(character.hair_color_code)
	
	_set_sprite(%Torso, character.torso_config.texture, Color.WHITE)
	_set_sprite(%Head, character.head_config.texture, character.skin_color_code)
	_set_sprite(%HairBack, character.hair_config.texture, character.hair_color_code)
	_set_sprite(%HairFront, character.hair_config.front_texture, character.hair_color_code)
	

func _set_sprite(sprite: Sprite2D, texture: Texture2D, color: Color) -> void:
	if texture != null:
		sprite.visible = true
		sprite.texture = texture
		#sprite.modulate = color
	else:
		sprite.visible = false
	
