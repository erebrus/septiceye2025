extends MarginContainer

signal claim_selected(claim: Claim)


var claim: Claim:
	set(value):
		claim = value
		if is_node_ready():
			_setup()
	

func _ready() -> void:
	if claim != null:
		_setup()
	

func _setup() -> void:
	%Label.text = claim.statement
	

func _on_gui_input(event: InputEvent):
	if event.is_action_released("left_click"):
		claim_selected.emit(claim)


func _on_mouse_entered():
	Globals.ui_sfx._on_button_entered()
