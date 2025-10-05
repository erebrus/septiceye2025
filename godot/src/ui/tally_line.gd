@tool
class_name TallyLine extends Control

const BLOCK_SCENE:=preload("res://src/ui/tally_block.tscn")
@onready var tally_container: HBoxContainer = $HBoxContainer/TallyContainer
@onready var label: Label = $HBoxContainer/Label

@export var title:String:
	set(_v):
		title=_v
		_update_label()

@export var expected:int:
	set(_v):
		expected=_v
		_update_label()	
		
var count:int = 0

func _update_label():
	if expected:
		$HBoxContainer/Label.text="%s (%d):" % [title, expected]
	else:
		$HBoxContainer/Label.text="%s:" % [title]

func reset():
	count=0
	GameUtils.clear_node(tally_container)

func add():
	if count == tally_container.get_child_count():
		_add_new_block()
	get_last_block().add()
	
func _add_new_block():
	var block = BLOCK_SCENE.instantiate()
	block.reset()
	tally_container.add_child(block)
	return
	
func get_last_block():
	return tally_container.get_child(tally_container.get_child_count()-1)
		
		
