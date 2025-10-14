class_name SceneManager extends Object


static func load_scene(parent: Node, scene: PackedScene) -> Node:
	var new_node = scene.instantiate()
	parent.add_child(new_node)
	return new_node


static func unload_scene(scene: Node) -> void:
	scene.queue_free()
