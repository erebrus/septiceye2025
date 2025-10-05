extends Control


func _on_button_pressed() -> void:
	Events.level_ended.emit()
