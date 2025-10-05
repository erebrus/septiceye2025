class_name Character extends Resource

enum Trait {
	RELIGION,
	GENDER,
	HAIR_COLOR,
	SKIN_COLOR,
	RELIGION_TSHIRT,
}

enum Gender {
	UNKNOWN,
	MALE,
	FEMALE
}

enum HairColor {
	UNKNOWN,
	GREEN,
	ORANGE,
	BROWN, 
	GRAY,
	BLACK,
	BLONDE,
	PINK,
	RED,
}

enum SkinColor {
	UNKNOWN,
	PINK,
	BEIGE,
	RED, 
	BROWN, 
	BLUE,
}

enum ClothesColor1 {
	UNKNOWN,
	RED,
	BLUE,
	BLACK,
	GREEN,
	WHITE,
	PINK,
	PURPLE,
	GRAY,
}

enum ClothesColor2 {
	UNKNOWN,
	RED,
	BLUE,
	BLACK,
	GREEN,
	WHITE,
	PINK,
	PURPLE,
	GRAY,
}

enum ColorChannel {
	NONE,
	HAIR,
	SKIN,
	CLOTHES_1,
	CLOTHES_2,
}

var name: String
var is_in_list: bool = true
var gender: Gender
var religion: Types.Religion

var hair_color: HairColor
var skin_color: SkinColor
var clothes_1_color: ClothesColor1
var clothes_2_color: ClothesColor2

var parts: Dictionary[String, PartConfig]
var colors: Dictionary[ColorChannel, int]
var forbidden_topics: Array[String]
var claims: Array[Claim]

var destination: Types.Destination


func filter_part_allowed_values(part: String, values: Array[String]) -> Array[String]:
	var allowed_values: Array[String]
	for value in values:
		var config = Globals.character_generator.parts_config[part][value]
		if gender == config.gender or config.gender == Gender.UNKNOWN:
			allowed_values.append(value)
	
	for config in parts.values():
		if part in config.allowed_parts:
			GameUtils._array_interect(allowed_values, config.allowed_parts[part])
	return allowed_values
	

func get_trait(soul_trait: Trait) -> int:
	match soul_trait:
		Trait.RELIGION: return religion
		Trait.GENDER: return gender
		Trait.HAIR_COLOR: return hair_color
		Trait.SKIN_COLOR: return skin_color
		Trait.RELIGION_TSHIRT: return parts["torso"].religion
	
	GSLogger.error("Unknown trait %s" % Character.Trait.keys()[soul_trait])
	return 0
	

func set_trait(soul_trait: Trait, value: int) -> void:
	match soul_trait:
		Trait.RELIGION: religion = value as Types.Religion
		Trait.GENDER: gender = value as Gender
		Trait.HAIR_COLOR: hair_color = value as HairColor
		Trait.SKIN_COLOR: skin_color = value as SkinColor
		Trait.RELIGION_TSHIRT: GSLogger.error("part traits should be handled by generator")
		_: GSLogger.error("Unknown trait %s" % Character.Trait.keys()[soul_trait])
	

func get_color_code(channel: ColorChannel) -> Color:
	var gen = Globals.character_generator
	match channel:
		ColorChannel.HAIR: return gen.hair_colors[hair_color]
		ColorChannel.SKIN: return gen.skin_colors[skin_color]
		ColorChannel.CLOTHES_1: return gen.clothes_1_colors[clothes_1_color]
		ColorChannel.CLOTHES_2: return gen.clothes_2_colors[clothes_2_color]
		_: return Color.WHITE
	

func has_topic(topic:String) -> bool:
	for claim in claims:
		if claim.topic == topic:
			return true
	return forbidden_topics.has(topic)
	

func has_claim(topic:String, claim_to_check:String)->bool:
	for claim in claims:
		if claim.topic == topic and \
			claim_to_check in claim.ids:
				return true
	return false
