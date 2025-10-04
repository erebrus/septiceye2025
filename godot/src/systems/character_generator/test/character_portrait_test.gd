extends Node

var part_options: Dictionary[String, OptionButton]

@onready var portrait = $CharacterPortrait
@onready var passport = $Passport
@onready var generator = Globals.character_generator

@onready var religion_options = %ReligionOptions
@onready var gender_options = %GenderOptions
@onready var hair_color_options = %HairColorOptions
@onready var skin_color_options = %SkinColorOptions
@onready var clothes_1_color_options = %Clothes1Options
@onready var clothes_2_color_options = %Clothes2Options

@onready var container: Container = %Container


func _ready() -> void:
	%Passport.show()
	
	for i in Types.Religion:
		religion_options.add_item(i, Types.Religion[i])
	for i in Character.Gender:
		gender_options.add_item(i, Character.Gender[i])
	for i in Character.HairColor:
		hair_color_options.add_item(i, Character.HairColor[i])
	for i in Character.SkinColor:
		skin_color_options.add_item(i, Character.SkinColor[i])
	for i in Character.ClothesColor1:
		clothes_1_color_options.add_item(i, Character.ClothesColor1[i])
	for i in Character.ClothesColor2:
		clothes_2_color_options.add_item(i, Character.ClothesColor2[i])
	
	for part in generator.parts_config:
		var variants = generator.parts_config[part]
		var label = Label.new()
		label.text = part
		container.add_child(label)
		var options = OptionButton.new()
		options.add_item("Any")
		
		for variant in variants:
			options.add_item(variant)
		options.item_selected.connect(_on_part_selected.bind(part))
		
		container.add_child(options)
		part_options[part] = options
		
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
	character.clothes_1_color = clothes_1_color_options.selected
	character.clothes_2_color = clothes_2_color_options.selected
	
	for part in generator.parts_config:
		var index = part_options[part].selected
		if index > 0:
			character.parts[part] = generator.parts_config[part].values()[index-1]
	
	generator.complete(character)
	
	%HairColor.color = character.get_color_code(Character.ColorChannel.HAIR)
	%SkinColor.color = character.get_color_code(Character.ColorChannel.SKIN)
	%Clothes1Color.color = character.get_color_code(Character.ColorChannel.CLOTHES_1)
	%Clothes2Color.color = character.get_color_code(Character.ColorChannel.CLOTHES_2)
	
	portrait.character = character
	passport.character = character
	

func _on_religion_options_item_selected(index):
	portrait.Types.Religion = index
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
	


func _on_clothes_1_options_item_selected(index):
	portrait.character.clothes_1_color = index
	_update() 


func _on_clothes_2_options_item_selected(index):
	portrait.character.clothes_2_color = index
	

func _on_part_selected(index: int, part: String):
	if  index == 0:
		return
	
	var config = generator.parts_config[part].values()[index-1]
	portrait.character.parts[part] = config
	_update()
	

func _on_hair_color_color_changed(color):
	generator.hair_colors[portrait.character.hair_color] = color
	_update()
	

func _on_skin_color_color_changed(color):
	generator.skin_colors[portrait.character.skin_color] = color
	_update()
	

func _on_clothes_1_color_color_changed(color):
	generator.clothes_1_colors[portrait.character.clothes_1_color] = color
	_update()

func _on_clothes_2_color_color_changed(color):
	generator.clothes_2_colors[portrait.character.clothes_2_color] = color
	_update()
