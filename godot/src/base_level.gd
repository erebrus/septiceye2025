class_name BaseLevel extends Node


@export var override_game_state: GameState

@export var extra_souls_in_list: int = 5
@export var extra_souls_not_in_list: int = 2 

@export var quotas: Dictionary[Types.Destination, int]


var game_state:GameState
@export var character_queue: Array[Character]

@onready var portrait: CharacterPortrait = %CharacterPortrait
@onready var start_day_button: BaseButton = %StartDayButton


func _ready() -> void:
	portrait.hide()
	

func set_state(_game_state:GameState):
	game_state = _game_state
	game_state.quotas.clear()
	
	for destination in quotas:
		game_state.quotas[destination] = 0
	
	if game_state.character_queue.is_empty():
		game_state.character_queue = character_queue
	else:
		character_queue = game_state.character_queue
	


func generate() -> void:
	for destination in quotas:
		for _i in quotas[destination]:
			GSLogger.info("Generating character with destination: %s" % Types.Destination.keys()[destination])
			character_queue.append(_generate_character(destination, []))
	
	for i in extra_souls_in_list:
		GSLogger.info("Generating extra in-list character")
		character_queue.append(_generate_character())
		
	for i in extra_souls_not_in_list:
		GSLogger.info("Generating extra not-in-list character")
		var character := _generate_character()
		character.is_in_list = false
		character_queue.append(character)
		
	
	character_queue.shuffle()
	

func _generate_character(destination: Types.Destination = Types.Destination.A, rules: Array = []) -> Character:
	var character = Character.new()
	
	# TODO: configure character based on rules
	
	Globals.character_generator.complete(character)
	return character
	

func _on_manual_button_pressed():
	Events.show_manual_requested.emit()
	

func _on_start_day_button_pressed():
	Events.day_started.emit()
	start_day_button.hide()
	

func _on_scheduled_deaths_button_pressed():
	Events.show_list_requested.emit()
