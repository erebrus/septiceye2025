extends Area2D

signal opened

@onready var open_sfx: AudioStreamPlayer = $openSfx
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var is_open = false

func close():
	is_open = false
	$closeSfx.play()
	animation_player.play("close")
	await animation_player.animation_finished
	Events.day_finished.emit()
	

func open():
	is_open = true
	$openSfx.play()
	animation_player.play("open")
	await animation_player.animation_finished
	opened.emit()
	Events.day_started.emit()
	

func _on_input_event(_viewport, event: InputEvent,_shape_idx):
	if event.is_action_released("left_click"):
		if not is_open:
			open()


func _on_mouse_entered():
	Globals.ui_sfx._on_button_entered()
