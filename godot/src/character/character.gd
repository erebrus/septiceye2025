class_name Character extends Resource

enum BodyPart {
	TORSO,
	HEAD,
	HAIR,
	EYEBROWS,
	EYES,
	NOSE,
	MOUTH,
	FACE_HAIR,
	HEAD_ACCESSORY,
	FACE_ACCESSORY,
}

enum Torso {
	DEFAULT,
}

enum Head {
	DEFAULT,
}

enum Hair {
	DEFAULT,
}

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
