class_name Character extends Resource

enum Trait {
	RELIGION,
	GENDER,
	HAIR_COLOR,
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

var name: String
var gender: Gender
var religion: Religion

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

var skin_color:= Color.WHITE
var hair_color:= Color.WHITE


func get_trait(soul_trait: Trait) -> int:
	match soul_trait:
		Trait.RELIGION: return religion
		Trait.GENDER: return gender
	
	GSLogger.error("Unknown trait %s" % soul_trait)
	return 0
