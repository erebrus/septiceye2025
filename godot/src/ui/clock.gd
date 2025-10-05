class_name Clock extends Control

signal timeout

@onready var timer = $Timer
@onready var handle: TextureRect = $Base/Handle

@export var total_time:= 60.0
var current_time:=0.0

func _ready():
	reset()
	Events.day_started.connect(func():start())
	Events.day_finished.connect(func():timer.stop())


func reset():
	current_time = 0
	update_handle()
	
func start():
	timer.start()

func update_handle():
	handle.rotation_degrees = (current_time/60)*360


func _on_timer_timeout() -> void:
	current_time += 1
	update_handle()
	if current_time==total_time:
		timer.stop()
		timeout.emit()
