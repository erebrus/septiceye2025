extends Node

@onready var portrait = $CharacterPortrait
@onready var generator = Globals.character_generator


func _ready() -> void:
	for i in Character.Torso:
		%TorsoOptions.add_item(i, Character.Torso[i])
	for i in Character.Head:
		%HeadOptions.add_item(i, Character.Head[i])
	for i in Character.Hair:
		%HairOptions.add_item(i, Character.Hair[i])
	
	_on_generate_pressed()
	

func _on_generate_pressed():
	var character = generator.generate()
	%TorsoOptions.select(character.torso)
	%HeadOptions.select(character.head)
	%HairOptions.select(character.hair)
	%HairColor.color = character.hair_color
	%SkinColor.color = character.skin_color
	portrait.character = character
	

func _on_torso_options_item_selected(index):
	portrait.character.torso = index
	portrait._setup()
	

func _on_head_options_item_selected(index):
	portrait.character.head = index
	portrait._setup()
	

func _on_hair_options_item_selected(index):
	portrait.character.hair = index
	portrait._setup()
	

func _on_hair_color_color_changed(color):
	portrait.character.hair_color = color
	portrait._setup()
	

func _on_skin_color_color_changed(color):
	portrait.character.skin_color = color
	portrait._setup()
	
