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
