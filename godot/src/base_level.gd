class_name BaseLevel extends Node


@export var override_game_state: GameState

@export var extra_souls: int = 5
@export var claims_per_soul: int = 2

@export var quotas: Dictionary[Types.Destination, int]
@export var ruleset: RuleSet

var game_state:GameState
@export var character_queue: Array[Character]

@onready var portrait: CharacterPortrait = %CharacterPortrait
@onready var passport_button: BaseButton = %PassportButton
@onready var shutter: Area2D = $Shutter
@onready var summary_board: Control = $SummaryBoard
@onready var list_sfx: AudioStreamPlayer = $sfx/ListSfx
@onready var passport_sfx: AudioStreamPlayer = $sfx/PassportSfx


func _ready() -> void:
	Events.day_started.connect(_on_day_started)
	Events.character_stamped.connect(_on_character_stamped)
	portrait.hide()
	passport_button.hide()
	add_rules()
	generate()
	Events.pre_day_started.emit(quotas, extra_souls, ruleset)
	_on_manual_button_pressed()
	await get_tree().process_frame
	summary_board.reset()
	var job = Globals.game.game_state.current_job_title
	Events.job_changed.emit(job,job)

	
	
func add_rules():
	var new_rules:Array[Rule]= Globals.game.get_rules_for_day()
	ruleset.rules.append_array(new_rules)
		
func set_state(_game_state:GameState):
	game_state = _game_state
	game_state.quotas.clear()
	
	for destination in quotas:
		game_state.quotas[destination] = 0
	summary_board.set_quotas(quotas)
	
	game_state.character_queue = character_queue
	

func generate() -> void:
	var target := quotas.duplicate()
	var num_extra := 0
	
	for character in character_queue:
		GSLogger.info("Counting custom character")
		Globals.character_generator.complete(character, claims_per_soul)
		character.destination = ruleset.expected_fate_for(character)
		num_extra += _count_character(character, target)
		
	for rule in ruleset.rules:
		GSLogger.info("Generating character which meets rule: %s" % rule)
		var character = Globals.character_generator.generate_for_rule(rule, claims_per_soul)
		character.destination = ruleset.expected_fate_for(character)
		character_queue.append(character)
		num_extra += _count_character(character, target)
	
	for destination in target:
		for _i in target[destination]:
			GSLogger.info("Generating character with destination: %s" % Types.Destination.keys()[destination])
			character_queue.append(Globals.character_generator.generate_for_destination(destination, ruleset, claims_per_soul))
	
	for _i in range(num_extra, extra_souls):
		GSLogger.info("Generating extra character")
		var character = Globals.character_generator.generate(claims_per_soul)
		character.destination = ruleset.expected_fate_for(character)
		character_queue.append(character)
		
	character_queue.shuffle()
	

func next_character() -> void:
	var character = character_queue.front()
	Events.character_entered.emit(character)
	
	# TODO: character enter animation / sfx
	portrait.show()
	passport_button.show()


func _count_character(character: Character, target: Dictionary[Types.Destination, int]) -> int:
	if target.has(character.destination):
		target[character.destination] -= 1
		return 0
	else:
		return -1
	

func _on_manual_button_pressed():
	Events.show_manual_requested.emit()
	

func _on_scheduled_deaths_button_pressed():
	Events.show_list_requested.emit()
	list_sfx.play()
	

func _on_passport_button_pressed():
	Events.show_passport_requested.emit()
	passport_sfx.play()
	

func _on_return_stamp_pressed():
	Events.stamp_requested.emit(Types.Destination.RETURN)
	

func _on_heaven_stamp_pressed():
	Events.stamp_requested.emit(Types.Destination.HEAVEN)
	

func _on_reincarnation_stamp_pressed():
	Events.stamp_requested.emit(Types.Destination.REINCARNATE)
	

func _on_purgatory_stamp_pressed():
	Events.stamp_requested.emit(Types.Destination.PURGATORY)
	

func _on_hell_stamp_pressed():
	Events.stamp_requested.emit(Types.Destination.HELL)
	

func _on_day_started() -> void:
	await get_tree().create_timer(0.5).timeout
	next_character()
	

func _on_character_stamped(_destination: Types.Destination, _expected: Types.Destination) -> void:
	# TODO: character leave animation/sfx
	portrait.hide()
	passport_button.hide()
	
	character_queue.pop_front()
	Events.character_left.emit()
	
	if character_queue.is_empty():
		Events.day_finished.emit()
	else:
		await get_tree().create_timer(0.5).timeout
		next_character()
	
	


func _on_clock_timeout() -> void:
	shutter.close()
	portrait.hide()
	passport_button.hide()
	
	
