class_name Claim extends Resource

var ids: Array[String]=[]

var topic: String
var statement: String
var follow_up: String

func has_all_ids(value: Array[String]) -> bool:
	for id in value:
		if not ids.has(id):
			return false
	return true
	

func has_any_id(value: Array[String]) -> bool:
	for id in value:
		if ids.has(id):
			return true
	return false
