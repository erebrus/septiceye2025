extends Node

@onready var portrait = $CharacterPortrait
@onready var passport = $Passport
@onready var generator = Globals.character_generator

@onready var religion_options = %ReligionOptions
@onready var gender_options = %GenderOptions
@onready var hair_color_options = %HairColorOptions
@onready var skin_color_options = %SkinColorOptions

@onready var torso_options = %TorsoOptions
@onready var head_options = %HeadOptions
@onready var hair_options = %HairOptions


func _ready() -> void:
	for i in Character.Religion:
		religion_options.add_item(i, Character.Religion[i])
	for i in Character.Gender:
		gender_options.add_item(i, Character.Gender[i])
	for i in Character.HairColor:
		hair_color_options.add_item(i, Character.HairColor[i])
	for i in Character.SkinColor:
		skin_color_options.add_item(i, Character.SkinColor[i])
	
	for i in Character.Torso:
		torso_options.add_item(i, Character.Torso[i])
	for i in Character.Head:
		head_options.add_item(i, Character.Head[i])
	for i in Character.Hair:
		hair_options.add_item(i, Character.Hair[i])
	
	_on_generate_pressed()
	

func _update() -> void:
	portrait._setup()
	passport._setup()
	

func _on_generate_pressed():
	var character = Character.new()
	character.religion = religion_options.selected
	character.gender = gender_options.selected
	character.hair_color = hair_color_options.selected
	character.skin_color = skin_color_options.selected
	
	generator.complete(character)
	
	torso_options.select(character.torso)
	head_options.select(character.head)
	hair_options.select(character.hair)
	
	%HairColor.color = character.hair_color_code
	%SkinColor.color = character.skin_color_code
	portrait.character = character
	passport.character = character
	

func _on_religion_options_item_selected(index):
	portrait.character.religion = index
	_update() 
	

func _on_gender_options_item_selected(index):
	portrait.character.gender = index
	_update() 
	

func _on_hair_color_options_item_selected(index):
	portrait.character.hair_color = index
	_update() 
	

func _on_skin_color_options_item_selected(index):
	portrait.character.skin_color = index
	_update() 
	

func _on_torso_options_item_selected(index):
	portrait.character.torso = index
	_update() 
	

func _on_head_options_item_selected(index):
	portrait.character.head = index
	_update() 
	

func _on_hair_options_item_selected(index):
	portrait.character.hair = index
	_update() 
	

func _on_hair_color_color_changed(color):
	portrait._set_hair_color(color)
	

func _on_skin_color_color_changed(color):
	portrait._set_skin_color(color)
	
