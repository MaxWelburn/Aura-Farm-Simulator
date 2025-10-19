@tool class_name Crystal extends Area2D

@export var connected_color_source: Node2D
var filled: bool = false

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if connected_color_source:
			connected_color_source.global_position = global_position
			
