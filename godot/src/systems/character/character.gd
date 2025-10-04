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
	GRAY
}

enum SkinColor {
	UNKNOWN,
	PINK,
	BEIGE,
	RED, 
	BROWN
}

enum ClothesColor1 {
	UNKNOWN,
	RED,
	BLUE,
	BLACK,
}

enum ClothesColor2 {
	UNKNOWN,
	RED,
	BLUE,
	BLACK,
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
var hair_color_code: Color:
	get:
		return Globals.character_generator.hair_colors[hair_color]

var skin_color: SkinColor
var skin_color_code: Color:
	get:
		return Globals.character_generator.skin_colors[skin_color]

var clothes_1_color: ClothesColor1
var clothes_2_color: ClothesColor2

var parts: Dictionary[String, PartConfig]
var colors: Dictionary[ColorChannel, int]

var destination: Types.Destination


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
		Trait.RELIGION_TSHIRT: parts["torso"] = Globals.character_generator.get_religion_part("torso", value)
		_: GSLogger.error("Unknown trait %s" % Character.Trait.keys()[soul_trait])
	


func get_color_code(channel: ColorChannel) -> Color:
	var gen = Globals.character_generator
	match channel:
		ColorChannel.HAIR: return gen.hair_colors[hair_color]
		ColorChannel.SKIN: return gen.skin_colors[skin_color]
		ColorChannel.CLOTHES_1: return gen.clothes_1_colors[clothes_1_color]
		ColorChannel.CLOTHES_2: return gen.clothes_2_colors[clothes_2_color]
		_: return Color.WHITE
	
