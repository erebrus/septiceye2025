class_name TallyBlock extends Control


@onready var tallies:Array = [$HBoxContainer/Tally1, $HBoxContainer/Tally2, $HBoxContainer/Tally3, $HBoxContainer/Tally4, $TallyCross]
@export var count := 0:
	set(_v):
		count = clampi(_v,0,5)
		for idx in range(tallies.size()):
			tallies[idx].visible = idx< count

func reset():
	count = 0
	

func add() -> bool:
	if count < 5:
		count+=1
		return true
	else:
		return false
		
