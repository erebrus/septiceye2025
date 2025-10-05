@tool
extends Node2D

signal dismissed
signal clicked


@export_range(0, 4, 1) var arrow: int:
	set(value):
		arrow = value
		_setup()

@export var text: String:
	set(value):
		text = value
		%Label.text = value
	
@export var dismiss_on_click: bool = true

var shown: bool 

@onready var arrows = [
	%Arrow1, %Arrow2, %Arrow3, %Arrow4
]


func _ready() -> void:
	hide()
	_setup()
	

func _setup() -> void:
	if arrows == null:
		return
	for a in arrows.size():
		arrows[a].visible = a == arrow
	 

func _input(event: InputEvent):
	if not visible:
		return
	
	if event.is_action_released("left_click"):
		if dismiss_on_click:
			dismiss()
		clicked.emit()
	

func trigger() -> void:
	if shown:
		return
	shown = true
	show()
	

func dismiss() -> void: 
	if not visible:
		return
	dismissed.emit()
	hide()
