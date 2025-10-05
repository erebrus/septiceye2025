extends Control


func _ready():
	Events.job_changed.connect(_on_job_changed)
	
func _on_job_changed(new_job:Types.JobTitle, old_job:Types.JobTitle):
	for i in range(get_child_count()):
		get_child(i).visible = i == new_job

	
