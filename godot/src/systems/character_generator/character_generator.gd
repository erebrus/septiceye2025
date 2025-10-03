class_name CharacterGenerator extends Node

@export var torsos: Dictionary[Character.Torso, TorsoConfig]

@export var heads: Dictionary[Character.Head, PartConfig]

@export var hairs: Dictionary[Character.Hair, HairConfig]

@export var skin_colors: Array[Color]
@export var hair_colors: Array[Color]

var genders: Array[Character.Gender] = [Character.Gender.MALE, Character.Gender.FEMALE]
var religions: Array[Character.Religion]

@onready var name_generator: SoulNameGenerator = $NameGenerator


func _init() -> void:
	religions.assign(Character.Religion.values().filter(func(x): return x != Character.Religion.UNKNOWN))
	

func _ready() -> void:
	_initialize_missing_configs()
	

func complete(character: Character) -> void:
	if character.religion == Character.Religion.UNKNOWN:
		character.religion = religions.pick_random()
	
	if character.gender == Character.Gender.UNKNOWN:
		character.gender = genders.pick_random()
	
	character.name = name_generator.generate_name(character.gender)
	
	character.hair_color = hair_colors.pick_random()
	character.skin_color = skin_colors.pick_random()
	
	# TODO: randomize character generation taking into account allowed combinations (and level config?)
	

func generate() -> Character:
	var character = Character.new()
	complete(character)
	
	return character
	

func _initialize_missing_configs() -> void:
	# TODO: load all textures, figure out the part type and part id, and create default PartConfig
	pass
