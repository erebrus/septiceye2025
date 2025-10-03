class_name BaseLevel extends Node


@export var override_game_state: GameState

@export var extra_souls: int = 5

@export var quotas: Dictionary[Types.Destination, int]
@export var ruleset: RuleSet

var game_state:GameState
@export var character_queue: Array[Character]

@onready var portrait: CharacterPortrait = %CharacterPortrait
@onready var start_day_button: BaseButton = %StartDayButton


func _ready() -> void:
	portrait.hide()
	generate()
	

func set_state(_game_state:GameState):
	game_state = _game_state
	game_state.quotas.clear()
	
	for destination in quotas:
		game_state.quotas[destination] = 0
	
	game_state.character_queue = character_queue
	

func generate() -> void:
	var target := quotas.duplicate()
	var num_extra := 0
	
	for character in character_queue:
		GSLogger.info("Counting custom character")
		Globals.character_generator.complete(character)
		num_extra += _count_character(character, target)
		
	for rule in ruleset.rules:
		GSLogger.info("Generating character which meets rule: %s" % rule)
		var character = Globals.character_generator.generate_for_rule(rule)
		num_extra += _count_character(character, target)
	
	for destination in target:
		for _i in target[destination]:
			GSLogger.info("Generating character with destination: %s" % Types.Destination.keys()[destination])
			character_queue.append(_generate_character(destination))
	
	for _i in range(num_extra, extra_souls):
		GSLogger.info("Generating extra character")
		character_queue.append(Globals.character_generator.generate())
		
	
	character_queue.shuffle()
	

func _generate_character(destination: Types.Destination = Types.Destination.RETURN) -> Character:
	var character = Character.new()
	
	# TODO: configure character based on rules
	
	Globals.character_generator.complete(character)
	return character
	

func _count_character(character: Character, target: Dictionary[Types.Destination, int]) -> int:
	var destination = ruleset.expected_fate_for(character)
	if target.has(destination):
		target[destination] -= 1
		return 0
	else:
		return -1
	

func _on_manual_button_pressed():
	Events.show_manual_requested.emit()
	

func _on_start_day_button_pressed():
	Events.day_started.emit()
	start_day_button.hide()
	

func _on_scheduled_deaths_button_pressed():
	Events.show_list_requested.emit()
