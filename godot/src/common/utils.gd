extends Node

func clear_node(node:Node):

	while node.get_child_count() > 0 :
		var child = node.get_child(0)
		node.remove_child(child)
		child.queue_free()

func _array_interect(source: Array, other: Array) -> void:
	var result: Array
	for i in source:
		if other.has(i):
			result.append(i)
	
	source.assign(result)
	

func read_csv_file(path: String, skip_headers: bool = false) -> Array[Array]:
	var data: Array[Array]
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		GSLogger.error("Failed to open file: ", path)
		return data

	while not file.eof_reached():
		var line: Array[String]
		line.assign(file.get_csv_line(","))
		data.append(line)
	
	file.close()
	
	if skip_headers:
		return data.slice(1)
	else:
		return data
	
