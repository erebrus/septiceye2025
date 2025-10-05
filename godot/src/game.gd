class_name Game extends Node2D

const RULES_DATA_PATH = "res://src/resources/rules.csv"

@export var start_state:GameState
@export var game_state:GameState


var current_character: Character


@onready var level_manager: LevelManager = $LevelManager
@onready var fade_panel: FadePanel = %FadePanel

@onready var scheduled_deaths: ScheduledDeaths = %ScheduledDeaths
@onready var rule_manual: RuleManual = %RuleManual

var rules:Array[Rule]=[]

func _ready():
	load_rules()
	Events.level_ended.connect(_on_level_ended)
	fade_panel.fade_in()
	
	level_manager.load_first_level()
	Debug.set_levels(level_manager.levels)
	Globals.game = self
	
	Events.character_entered.connect(func(x): current_character = x)
	Events.character_stamped.connect(_on_character_stamped)

func _on_character_stamped(destination: Types.Destination, expected: Types.Destination):
	($Jingles.get_child(destination) as AudioStreamPlayer).play()
	
func _on_level_ended():
	fade_panel.fade_out()
	await fade_panel.fade_out_completed
	if not level_manager.is_last_level():
		fade_panel.fade_in()
	level_manager.load_next_level()
	


func _on_level_manager_game_completed() -> void:
	Globals.do_win()
	

func _on_level_manager_level_unloaded() -> void:
	pass
	

func get_level()->BaseLevel:
	return level_manager.current_level
	

func _on_level_manager_level_ready() -> void:
	if get_level().override_game_state:
		get_level().set_state(get_level().override_game_state)
	else:
		if level_manager.current_level_idx==0:
			game_state = start_state.duplicate()
		get_level().set_state(game_state)
		
	scheduled_deaths.set_state(game_state)
	rule_manual.ruleset = get_level().ruleset

func load_rules():
	var rule_data = GameUtils.read_csv_file(RULES_DATA_PATH, true)
	for rule_line in rule_data:
		rules.append(Rule.from_csv_line(rule_line))
	GSLogger.info("Loaded rules")
	
func get_rules_for_day() -> Array[Rule]:
	var day:int = level_manager.current_level_idx + 1
	var ret:Array[Rule] = []
	for rule in rules:
		if day >= rule.start_day and day <= rule.end_day:
			ret.append(rule)
	return ret
	
