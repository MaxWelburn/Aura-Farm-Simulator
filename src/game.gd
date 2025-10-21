extends Node2D

@export var orb_scene: RigidBody2D


func _ready() -> void:
	get_tree().paused = false


# doesn't reset grayscale though
func _on_button_pressed() -> void:
	var current_scene = get_tree().current_scene
	GameManager.regray()
	get_tree().reload_current_scene()
