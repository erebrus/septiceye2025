class_name CharacterPortrait extends Node2D


@export var should_override_color: bool = false
@export var override_color: Color = Color.WHITE


var character: Character:
	set(value):
		character = value
		if is_node_ready():
			_setup()
	

@onready var generator: CharacterGenerator = Globals.character_generator

@onready var sprites: Dictionary[String, Array] = {
	"torso": [ %TorsoFront, %TorsoBack ],
	"face": [ %HeadFront, %HeadBack ],
	"hair": [ %HairFront, %HairBack ],
	"brows": [ %EyebrowsFront, %EyebrowsBack ],
	"eyes": [ %EyesFront, %EyesBack ],
	"nose": [ %NoseFront, %NoseBack ],
	"mouth": [ %MouthFront, %MouthBack ],
	"beard": [ %BeardFront, %BeardBack ],
}

func _ready() -> void:
	if character != null:
		_setup()
	
	Events.character_entered.connect(func(x): character = x)
	

func _setup() -> void:
	if character.parts.is_empty():
		return
	
	%BehindTorso.position = character.parts["torso"].head_position
	%InFrontOfTorso.position = character.parts["torso"].head_position
	
	for part in sprites:
		_set_sprites(part)
		_set_recolor(part)
	

func _set_recolor(part: String) -> void:
	if not part in character.parts:
		return
	
	if should_override_color:
		sprites[part].front().modulate = override_color
		sprites[part].back().modulate = override_color
	else:
		var config = character.parts[part]
		if config.back_no_recolor:
			sprites[part].back().modulate = Color.WHITE
		else:
			sprites[part].back().modulate = character.get_color_code(config.back_color)
			
		if config.front_no_recolor:
			sprites[part].front().modulate = Color.WHITE
		else:
			sprites[part].front().modulate = character.get_color_code(config.front_color)
		
		if part == "eyes":
			sprites[part].back().modulate = Color(1,1,1,0.5)
			
		

func _set_sprites(part: String) -> void:
	if not part in character.parts:
		sprites[part].back().hide()
		sprites[part].front().hide()
		return
	
	var config = character.parts[part]
	_set_sprite(sprites[part].back(), config.back_texture)
	_set_sprite(sprites[part].front(), config.front_texture)
	

func _set_sprite(sprite: Sprite2D, texture: Texture2D) -> void:
	if texture != null:
		sprite.visible = true
		sprite.texture = texture
	else:
		sprite.visible = false
	
