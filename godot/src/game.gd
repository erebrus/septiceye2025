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
var game_over:=false
func _ready():
	load_rules()
	Events.on_win.connect(_on_win)
	Events.on_lose.connect(_on_lose)
	Events.on_survived.connect(_on_survived)
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
	if level_manager.current_level_idx>0:
		show_warning()

func show_warning():
	var label := $HUDLayer/RulesChanged
	await get_tree().create_timer(1.2).timeout
	label.show()
	label.modulate.a=1
	await get_tree().create_timer(2).timeout
	var tween:=get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(label,"modulate",Color(1,1,1,0),.5)
	await tween.finished
	label.hide()
	
func sort_rule(a:Rule, b:Rule):
	if a.priority > b.priority:
		return true
	return false


func load_rules():
	var rule_data = GameUtils.read_csv_file(RULES_DATA_PATH, true)
	for rule_line in rule_data:
		var rule = ClaimRule.from_csv_line(rule_line)
		if rule != null:
			rules.append(rule)
	rules.sort_custom(sort_rule)
	for r in rules:
		GSLogger.info("Loaded rule: %s" % r.short_name)
	GSLogger.info("Loaded rules")
	
		
func get_rules_for_day() -> Array[Rule]:
	var day:int = level_manager.current_level_idx + 1
	var ret:Array[Rule] = []
	for rule in rules:
		if day >= rule.start_day and day <= rule.end_day:
			ret.append(rule)
	return ret

func _on_survived():
	$OverlayLayer/SurviveScreen.show()
	await get_tree().create_timer(2).timeout
	$OverlayLayer/SurviveScreen2.show()
	await get_tree().create_timer(2).timeout
	$OverlayLayer/SurviveScreen3.show()
	game_over=true
	await get_tree().create_timer(5).timeout
	Globals.go_to_main_menu()


func _on_lose():
	$OverlayLayer/LoseScreen.show()
	game_over=true
	await get_tree().create_timer(5).timeout
	Globals.go_to_main_menu()
		
func _on_win():
	$OverlayLayer/WinScreen.show()
	game_over=true
	await get_tree().create_timer(5).timeout
	Globals.go_to_main_menu()

func _on_screen_gui_input(event: InputEvent) -> void:
	if not game_over:
		return
	if event is InputEventMouseButton:
		var mev:= event as InputEventMouseButton
		if mev.pressed and mev.button_index==MOUSE_BUTTON_LEFT:
			Globals.go_to_main_menu()
	if Input.is_action_just_pressed("ui_cancel"):
		Globals.go_to_main_menu()
	
