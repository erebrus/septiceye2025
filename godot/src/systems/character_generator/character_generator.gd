class_name CharacterGenerator extends Node

const CLAIM_DATA_PATH = "res://src/resources/claims.csv"
const FOLLOW_UP_DATA_PATH = "res://src/resources/follow_ups.csv"


@export var part_config_path: String

@export var hair_colors: Dictionary[Character.HairColor, Color]
@export var skin_colors: Dictionary[Character.SkinColor, Color]
@export var clothes_1_colors: Dictionary[Character.ClothesColor1, Color]
@export var clothes_2_colors: Dictionary[Character.ClothesColor2, Color]

var parts_config: Dictionary[String, Dictionary]

var genders: Array[Character.Gender]
var religions: Array[Types.Religion]

var claims: Dictionary[String, Array]


@onready var name_generator: SoulNameGenerator = $NameGenerator


func _init() -> void:
	genders.assign(Character.Gender.values().filter(func(x): return x != Character.Gender.UNKNOWN))
	religions.assign(Types.Religion.values().filter(func(x): return x != Types.Religion.UNKNOWN))
	

func initialize() -> void:
	_initialize_missing_configs()
	_initialize_claims()
	

func complete(character: Character, min_claims: int = 0) -> void:
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
		
		var allowed_values = character.filter_part_allowed_values(part, parts_config[part].keys())
		_set_part(character, part, allowed_values)
		
	var allowed_topics = claims.keys()
	for claim in character.claims:
		allowed_topics.erase(claim.topic)
	
	for i in range(character.claims.size(), min_claims):
		var topic = allowed_topics.pick_random()
		allowed_topics.erase(topic)
		
		assert(not allowed_topics.is_empty())
		character.claims.append(claims[topic].pick_random())
		
	

func generate(min_claims: int = 0) -> Character:
	var character = Character.new()
	complete(character, min_claims)
	return character
	

func generate_for_rule(rule: Rule, min_claims: int = 0) -> Character:
	var character = Character.new()
	if rule.religion != Types.Religion.UNKNOWN:
		character.religion = rule.religion
	rule.make_character_meet(character)
	complete(character, min_claims)
	return character
	

func generate_for_destination(destination: Types.Destination, ruleset: RuleSet, min_claims: int = 0) -> Character:
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
	
	complete(character, min_claims)
	character.destination = ruleset.expected_fate_for(character)
	
	return character
	

func choose_trait(character: Character, soul_trait: Character.Trait, allowed_values: Array) -> void:
	match soul_trait:
		Character.Trait.RELIGION_TSHIRT:
			var variants: Array[String]
			for religion in allowed_values:
				for value in get_religion_parts("torso", religion):
					if not value in variants:
						variants.append(value)
				
			var values = character.filter_part_allowed_values("torso", variants)
			_set_part(character, "torso", values)
		_:
			character.set_trait(soul_trait, allowed_values.pick_random())
	

func get_trait_values(soul_trait: Character.Trait) -> Array:
	match soul_trait:
		Character.Trait.RELIGION: return religions
		Character.Trait.GENDER: return genders
		Character.Trait.HAIR_COLOR: return hair_colors.keys()
		Character.Trait.SKIN_COLOR: return skin_colors.keys()
		Character.Trait.RELIGION_TSHIRT: return Types.Religion.values()
	
	GSLogger.error("Unknown trait %s" % Character.Trait.keys()[soul_trait])
	return [] 
	

func get_religion_parts(part: String, religion: Types.Religion) -> Array:
	var variants = parts_config[part].values()
	var religion_variants = variants.filter(func(x): return x.religion == religion or religion == Types.Religion.UNKNOWN)
	return religion_variants.map(func(x): return x.variant)
	

func _set_part(character: Character, part: String, allowed_values: Array[String]) -> void:
	if allowed_values.is_empty():
		# TODO: error only if it's mandatory part
		return
	
	var variant = allowed_values.pick_random()
	character.parts[part] = parts_config[part][variant]
	

func _initialize_missing_configs() -> void:
	_load_part_directory(part_config_path)
	if parts_config.is_empty():
		GSLogger.error("No parts loaded!")
	

func _load_part_directory(path: String) -> void:
	GSLogger.info("Loading part configs in %s" % path)
	
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir():
				_load_part_directory(path.path_join(file_name))
			else:
				GSLogger.info("Loading part %s %s" % [path, file_name])
				var res = load(path.path_join(file_name.trim_suffix(".remap")))
				if not res is PartConfig:
					GSLogger.warn("Resource is not a PartConfig")
					continue
				var config: PartConfig = res
				
				if not config.part in parts_config:
					var dict: Dictionary[String, PartConfig]
					parts_config[config.part] = dict
				
				parts_config[config.part][config.variant] = config
				GSLogger.info("Added config %s %s" % [config.part, config.variant])
			
			file_name = dir.get_next()
	else:
		GSLogger.error("An error occurred when trying to access the path.")
	

func _initialize_claims() -> void:
	GSLogger.info("Loading claims")
	var claim_data = GameUtils.read_csv_file(CLAIM_DATA_PATH, true)
	var follow_up_data = GameUtils.read_csv_file(FOLLOW_UP_DATA_PATH, true)
	
	var unused_claims: Array[String]
	var claim_dict: Dictionary
	for row in claim_data:
		claim_dict[row[2]] = row
		unused_claims.append(row[2])
	
	for row in follow_up_data:
		var claim_id = row[0]
		var final_claims = row[1].split(";")
		var follow_up = row[2]
		
		assert(claim_dict.has(claim_id), "Follow up with unknown claim id %s" % claim_id)
		
		var claim = _create_claim(claim_dict[claim_id])
		claim.ids.assign(final_claims)
		claim.follow_up = follow_up
		
		unused_claims.erase(claim_id)
		
	for claim_id in unused_claims:
		GSLogger.info("Adding claim without followup %s" % claim_id)
		var claim = _create_claim(claim_dict[claim_id])
		claim.ids = [claim_id]
		claim.follow_up = "I have nothing more to say about it."
	
	GSLogger.info("%s claims loaded" % claims.size())
	

func _create_claim(claim_data: Array) -> Claim:
	var claim = Claim.new()
	claim.topic = claim_data[1]
	claim.statement = claim_data[2]
	
	if claim.topic not in claims:
		var array: Array[Claim]
		claims[claim.topic] = array
	
	claims[claim.topic].append(claim)
	
	return claim
	
