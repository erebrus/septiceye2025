class_name GameState extends Resource
@export var character_queue: Array[Character]

@export var quotas: Dictionary[Types.Destination, int]
@export var current_job_title:=Types.JobTitle.GRIM_REAPER
@export var level_points:Array[int]
