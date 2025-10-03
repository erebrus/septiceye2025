class_name CharacterGenerator extends Node

@export var torsos: Dictionary[Character.Torso, TorsoConfig]

@export var heads: Dictionary[Character.Head, PartConfig]

@export var hairs: Dictionary[Character.Hair, HairConfig]

@export var skin_colors: Array[Color]
@export var hair_colors: Array[Color]


func _ready() -> void:
	_initialize_missing_configs()
	

func generate() -> Character:
	var character = Character.new()
	character.hair_color = hair_colors.pick_random()
	character.skin_color = skin_colors.pick_random()
	
	# TODO: randomize character generation taking into account allowed combinations (and level config?)
	
	return character
	

	
func _initialize_missing_configs() -> void:
	# TODO: load all textures, figure out the part type and part id, and create default PartConfig
	pass
