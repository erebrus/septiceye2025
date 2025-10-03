class_name RuleManual extends PopupPanel

var ruleset: RuleSet:
	set(value):
		ruleset = value 
		if is_node_ready():
			_setup()
	

@onready var container: Container = %RuleContainer


func _ready() -> void:
	if ruleset != null:
		_setup()
	
	Events.show_manual_requested.connect(popup)
	

func _setup() -> void:
	for rule in ruleset.rules:
		var label = Label.new()
		label.text = rule.description
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.custom_minimum_size = Vector2(500,0)
		container.add_child(label)
