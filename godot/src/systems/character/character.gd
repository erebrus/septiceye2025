class_name Character extends Resource

enum Trait {
	RELIGION,
	GENDER,
	HAIR_COLOR,
	SKIN_COLOR,
}

enum Religion {
	UNKNOWN,
	A,
	B,
	C,
	D
}

enum Gender {
	UNKNOWN,
	MALE,
	FEMALE
}

enum Torso {
	UNKNOWN,
	DEFAULT,
}

enum Head {
	UNKNOWN,
	DEFAULT,
}

enum Hair {
	UNKNOWN,
	DEFAULT,
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

var name: String
var is_in_list: bool = true
var gender: Gender
var religion: Religion

var hair_color: HairColor
var hair_color_code: Color:
	get:
		return Globals.character_generator.hair_colors[hair_color]

var skin_color: SkinColor
var skin_color_code: Color:
	get:
		return Globals.character_generator.skin_colors[skin_color]

var torso: Torso
var torso_config: TorsoConfig:
	get:
		return Globals.character_generator.torsos[torso]

var head: Head
var head_config: PartConfig:
	get:
		return Globals.character_generator.heads[head]

var hair: Hair
var hair_config: HairConfig:
	get:
		return Globals.character_generator.hairs[hair]



func get_trait(soul_trait: Trait) -> int:
	match soul_trait:
		Trait.RELIGION: return religion
		Trait.GENDER: return gender
		Trait.HAIR_COLOR: return hair_color
		Trait.SKIN_COLOR: return skin_color
	
	GSLogger.error("Unknown trait %s" % soul_trait)
	return 0
