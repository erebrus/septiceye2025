extends Control
const MET_QUOTA_POINTS:=50
const NOT_MET_QUOTA_POINTS:=-50
const CORRECT=15
const INCORRECT=-10
var correct:=0
var incorrect:=0

var back_to_life:=0
var heaven:=0
var reincarnation:=0
var purgatory:=0
var hell:=0

var quotas:Dictionary[Types.Destination, int]= {}
var score:=0
@onready var button: Button = %Button

@onready var day_label: Label = $BG/Margin/VBox/DayLabel
@onready var grid: GridContainer = $BG/Margin/VBox/Margin/Grid
@onready var points: Label = $BG/Margin/VBox/Points
@onready var promotion: Label = $BG/Margin/VBox/Promotion

var need_restart:=false
func _ready() -> void:
	Events.character_stamped.connect(_on_character_stamped)
	Events.day_finished.connect(on_day_finished)
	
func on_day_finished():
	show()
	run()
func _on_character_stamped(destination: Types.Destination, expected: Types.Destination):
	if destination==expected:
		correct += 1
		score += CORRECT
	else:
		incorrect += 1
		score += INCORRECT
		
	match destination:
		Types.Destination.RETURN:
			back_to_life += 1
		Types.Destination.HEAVEN:
			heaven += 1
		Types.Destination.REINCARNATE:
			reincarnation += 1
		Types.Destination.PURGATORY:
			purgatory += 1
		Types.Destination.HELL:
			hell += 1

func reset():
	button.text="Next Day"
	button.hide()
	day_label.text = "Day %d - Summary" % [(Globals.game.level_manager.current_level_idx+1)]
	hide_all_rows()
	correct=0
	incorrect=0

	back_to_life=0
	heaven=0
	reincarnation=0
	purgatory=0
	hell=0
	score=0

	points.text = "Current Job Rating: %d" % Globals.game.game_state.current_points
	points.hide()
	promotion.hide()
func run():
	
	var interval = .5
	await get_tree().create_timer(interval).timeout
	show_row(0,"","", "Score" )
	show_row(1,"Correctly Processed:","%d" % correct, "%d" %(correct*CORRECT))
	await get_tree().create_timer(interval).timeout
	show_row(2,"Incorrectly Processed:","%d" % incorrect, "%d" %(incorrect*INCORRECT))
	await get_tree().create_timer(interval).timeout
	do_quota_row(3, "Back To Life Quota:", back_to_life, Types.Destination.RETURN)
	await get_tree().create_timer(interval).timeout
	do_quota_row(4, "Heaven Quota:", heaven, Types.Destination.HEAVEN)
	await get_tree().create_timer(interval).timeout
	do_quota_row(5, "Reincarnation Quota:", reincarnation, Types.Destination.REINCARNATE)
	await get_tree().create_timer(interval).timeout
	do_quota_row(6, "Purgatory Quota:", purgatory, Types.Destination.PURGATORY)
	await get_tree().create_timer(interval).timeout
	do_quota_row(7, "Hell Quota:", hell, Types.Destination.HELL)
	await get_tree().create_timer(interval).timeout

	show_row(8,"","", "" )
	
	show_row(9,"Total:","", "%d" % score)
	await get_tree().create_timer(interval).timeout
	

	var previous_job := Globals.game.game_state.current_job_title
	var previous_score := Globals.game.game_state.current_points
	#Globals.game.game_state.current_points+=score
	points.text = "Current Job Rating: %d" % previous_score
	points.show()
	var delta=sign(score)
	
	for i in range(abs(score)):
		Globals.game.game_state.current_points+=delta
		points.text = "Current Job Rating: %d" % Globals.game.game_state.current_points
		await get_tree().process_frame
		
	var new_job=Globals.game.game_state.get_position_for_score(Globals.game.game_state.current_points)
	promotion.text=""
	promotion.show()
	if new_job!=previous_job:
		Globals.game.game_state.current_job_title=new_job
		Events.job_changed.emit(new_job, previous_job)
		if new_job > previous_job:
			promotion.text= "Promoted to %s" % Types.JOB_TITLES[new_job]
			$promotionSfx.play()
		else:
			if Globals.game.game_state.current_points < 0:
				promotion.text= "You're not longer a %s" % Types.JOB_TITLES[0]
			else:
				promotion.text= "Demoted to %s" % Types.JOB_TITLES[new_job]
			$demotionSfx.play()
			
	else:
		if Globals.game.game_state.current_points < 0:
			promotion.text= "You're not longer a %s" % Types.JOB_TITLES[0]
			button.text="Continue"
		else:
			promotion.text= "Remained %s" % Types.JOB_TITLES[new_job]
	if Globals.game.level_manager.is_last_level():
		button.text="Continue"
	button.show()

func do_quota_row(idx:int, label:String, value:int, fate:Types.Destination):
	var quota:=0
	if fate in quotas:
		quota = quotas[fate]
	var quota_points=0 if quota == 0 else MET_QUOTA_POINTS if value >= quota else NOT_MET_QUOTA_POINTS
	show_row(idx,label, \
		"%d/%d" % [value,quota],\
		"%d" %(quota_points))
	score+=quota_points

	

func _on_button_pressed() -> void:
	Globals.ui_sfx.click_sfx.play()
	if Globals.game.game_state.current_points < 0:
		Events.on_lose.emit()
	elif Globals.game.level_manager.is_last_level():
		if Globals.game.game_state.current_job_title==Types.JobTitle.CELESTIAL_CLERK:			
			Events.on_win.emit()
		else:
			Events.on_survived.emit()
	else:
		Events.level_ended.emit()

func show_row(row_idx:int, label:String, value:String, credits:String):
	var idx = 3 * row_idx
	
		
	grid.get_child(idx).text=label
	grid.get_child(idx+1).text=value
	grid.get_child(idx+2).text=credits

	grid.get_child(idx).show()
	grid.get_child(idx+1).show()
	grid.get_child(idx+2).show()
	if label!="" or value !=""  or credits !="" :
		$rowSfx.play()

func hide_all_rows():
	for c in grid.get_children():
		c.hide()

func set_quotas(level_quotas:Dictionary[Types.Destination, int]):
	quotas=level_quotas.duplicate()
	for dest in Types.Destination.values():
		if dest not in quotas:
			quotas[dest]=0
	


func _on_button_mouse_entered() -> void:
	Globals.ui_sfx.hover_sfx.play()
