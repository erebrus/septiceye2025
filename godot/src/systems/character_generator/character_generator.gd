class_name CharacterGenerator extends Node

@export var torsos: Dictionary[Character.Torso, TorsoConfig]

@export var heads: Dictionary[Character.Head, PartConfig]

@export var hairs: Dictionary[Character.Hair, HairConfig]

@export var hair_colors: Dictionary[Character.HairColor, Color]

@export var skin_colors: Dictionary[Character.SkinColor, Color]


var genders: Array[Character.Gender]
var religions: Array[Types.Religion]

@onready var name_generator: SoulNameGenerator = $NameGenerator


func _init() -> void:
	genders.assign(Character.Gender.values().filter(func(x): return x != Character.Gender.UNKNOWN))
	religions.assign(Types.Religion.values().filter(func(x): return x != Types.Religion.UNKNOWN))
	

func _ready() -> void:
	_initialize_missing_configs()
	

func complete(character: Character) -> void:
	if character.religion == Types.Religion.UNKNOWN:
		character.religion = religions.pick_random()
	
	if character.gender == Character.Gender.UNKNOWN:
		character.gender = genders.pick_random()
	
	character.name = name_generator.generate_name(character.gender)
	
	if character.hair_color == Character.HairColor.UNKNOWN:
		character.hair_color = hair_colors.keys().pick_random()
	
	if character.skin_color == Character.SkinColor.UNKNOWN:
		character.skin_color = skin_colors.keys().pick_random()
	
	# TODO: randomize character generation taking into account allowed combinations (and level config?)
	

func generate() -> Character:
	var character = Character.new()
	complete(character)
	return character
	

func generate_for_rule(rule: Rule) -> Character:
	var character = Character.new()
	if rule.religion != Types.Religion.UNKNOWN:
		character.religion = rule.religion
	rule.make_character_meet(character)
	complete(character)
	return character
	

func generate_for_destination(destination: Types.Destination, ruleset: RuleSet) -> Character:
	var character = Character.new()
	character.religion = religions.pick_random()
	
	for rule in ruleset.rules:
		if not rule.should_apply(character):
			continue
		if destination in rule.met_destinations:
			if destination not in rule.unmet_destinations:
				rule.make_character_meet(character)
		elif destination in rule.unmet_destinations:
			rule.make_character_not_meet(character)
	
	complete(character)
	return character
	

func get_trait_values(soul_trait: Character.Trait) -> Array:
	match soul_trait:
		Character.Trait.RELIGION: return religions
		Character.Trait.GENDER: return genders
		Character.Trait.HAIR_COLOR: return hair_colors.keys()
		Character.Trait.SKIN_COLOR: return skin_colors.keys()
	
	GSLogger.error("Unknown trait %s" % Character.Trait.keys()[soul_trait])
	return [] 
	

func _initialize_missing_configs() -> void:
	# TODO: load all textures, figure out the part type and part id, and create default PartConfig
	pass
