class_name RuleManual extends Control

var ruleset: RuleSet:
	set(value):
		ruleset = value 
		if is_node_ready():
			_setup()
	
@onready var page_sfx: AudioStreamPlayer = $sfx/page

@onready var pages = [
	Page.new(%GenericTitle, %GenericContent, %GenericRules, %GenericButton),
	Page.new(%ReligionTitle1, %ReligionContent1, %ReligionRules1, %ReligionButton1),
	Page.new(%ReligionTitle2, %ReligionContent2, %ReligionRules2, %ReligionButton2),
	Page.new(%ReligionTitle3, %ReligionContent3, %ReligionRules3, %ReligionButton3),
	Page.new(%ReligionTitle4, %ReligionContent4, %ReligionRules4, %ReligionButton4),
]

func _ready() -> void:
	if ruleset != null:
		_setup()
	
	Events.show_manual_requested.connect(on_requested)
	hide()
	
func on_requested():	
	show()
	page_sfx.play()
func _input(event: InputEvent):
	if not visible:
		return
	
	if event.is_action_released("ui_cancel"):
		get_viewport().set_input_as_handled()
		hide()
	

func _setup() -> void:
	for religion in Types.Religion.values():
		var rules: Array[Rule]
		rules.assign(ruleset.rules.filter(func(x): return x.religion == religion))
		pages[religion].setup(rules)
		pages[religion].hide()
		pages[religion].button.pressed.connect(_on_tab_pressed.bind(religion))
	
	pages.front().show()
	

func _on_tab_pressed(religion: Types.Religion) -> void:
	page_sfx.play()
	for r in Types.Religion.values():
		if r == religion:
			pages[r].show()
		else:
			pages[r].hide()
	

func _on_gui_input(event: InputEvent):
	if event.is_action_released("left_click"):
		hide()
	

class Page:
	var title: Control
	var content: Control
	var container: Container
	var button: BaseButton
	
	func _init(_title: Control, _content: Control, _container: Container, _button: BaseButton) -> void:
		title = _title
		content = _content
		container = _container
		button = _button
		
		
	
	func setup(rules: Array[Rule]) -> void:
		for label in container.get_children():
			label.queue_free()
		
		for rule in rules:
			var label = Label.new()
			label.text = rule.description
			label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			label.custom_minimum_size = Vector2(50,0)
			label.theme_type_variation = "HeaderSmall"
			container.add_child(label)
	
	func show() -> void:
		_set_visibility(true)
		
	func hide() -> void:
		_set_visibility(false)
		
	func _set_visibility(value: bool) -> void:
		title.visible = value
		content.visible = value
		
	

func _on_hidden():
	Events.manual_hidden.emit()
