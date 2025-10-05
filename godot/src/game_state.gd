class_name GameState extends Resource
@export var character_queue: Array[Character]

@export var quotas: Dictionary[Types.Destination, int]
@export var current_job_title:=Types.JobTitle.GRIM_REAPER
@export var level_points:Array[int]
@export var current_points:=0


func get_position_for_score(score:int)->Types.JobTitle:
	for i in range(Types.JobTitle.values().size()-1,-1):
		if score > level_points[i]:
			return i
	return Types.JobTitle.GRIM_REAPER
	
