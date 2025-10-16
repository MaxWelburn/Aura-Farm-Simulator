extends Node2D

func _ready() -> void:
	GameManager.crystals_desired = get_child_count()
