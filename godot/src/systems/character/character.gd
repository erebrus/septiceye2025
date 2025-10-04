class_name Character extends Resource

enum Trait {
	RELIGION,
	GENDER,
	HAIR_COLOR,
	SKIN_COLOR,
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

var parts: Dictionary[String, PartConfig]

var destination: Types.Destination


func get_trait(soul_trait: Trait) -> int:
	match soul_trait:
		Trait.RELIGION: return religion
		Trait.GENDER: return gender
		Trait.HAIR_COLOR: return hair_color
		Trait.SKIN_COLOR: return skin_color
	
	GSLogger.error("Unknown trait %s" % Character.Trait.keys()[soul_trait])
	return 0
	

func set_trait(soul_trait: Trait, value: int) -> void:
	match soul_trait:
		Trait.RELIGION: religion = value as Types.Religion
		Trait.GENDER: gender = value as Gender
		Trait.HAIR_COLOR: hair_color = value as HairColor
		Trait.SKIN_COLOR: skin_color = value as SkinColor
		_: GSLogger.error("Unknown trait %s" % Character.Trait.keys()[soul_trait])

func get_color_code(channel: ColorChannel) -> Color:
	match channel:
		ColorChannel.HAIR: return hair_color_code
		ColorChannel.SKIN: return skin_color_code
		_: return Color.WHITE
