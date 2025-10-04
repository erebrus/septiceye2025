class_name CharacterGenerator extends Node

@export var part_config_path: String

@export var hair_colors: Dictionary[Character.HairColor, Color]
@export var skin_colors: Dictionary[Character.SkinColor, Color]
@export var clothes_1_colors: Dictionary[Character.ClothesColor1, Color]
@export var clothes_2_colors: Dictionary[Character.ClothesColor2, Color]


var parts_config: Dictionary[String, Dictionary]

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
	
	if character.clothes_1_color == Character.ClothesColor1.UNKNOWN:
		character.clothes_1_color = clothes_1_colors.keys().pick_random()
	
	if character.clothes_2_color == Character.ClothesColor2.UNKNOWN:
		character.clothes_2_color = clothes_2_colors.keys().pick_random()
	
	for part in parts_config:
		if part in character.parts:
			# part already pre-configured, skip
			continue
		
		var allowed_values =  parts_config[part].keys().duplicate()
		for config: PartConfig in character.parts.values():
			if part in config.allowed_parts:
				GameUtils._array_interect(allowed_values, config.allowed_parts[part])
			
		if allowed_values.is_empty():
			# TODO: error only if it's mandatory part
			continue
		
		var variant = allowed_values.pick_random()
		character.parts[part] = parts_config[part][variant]
	

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
	character.destination = ruleset.expected_fate_for(character)
	
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
	_load_part_directory(part_config_path)
	

func _load_part_directory(path: String) -> void:
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir():
				_load_part_directory(path.path_join(file_name))
			elif file_name.get_extension() == "tres":
				GSLogger.info("Loading part %s %s" % [path, file_name])
				var res = load(path.path_join(file_name))
				if not res is PartConfig:
					GSLogger.warn("Resource is not a PartConfig")
					continue
				var config: PartConfig = res
				
				if not config.part in parts_config:
					var dict: Dictionary[String, PartConfig]
					parts_config[config.part] = dict
				
				parts_config[config.part][config.variant] = config
				
			
			file_name = dir.get_next()
	else:
		GSLogger.error("An error occurred when trying to access the path.")
	


	
