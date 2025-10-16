class_name Orb extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	var hue: float = randf()
	var sat: float = randf_range(0.7, 1.0)
	var val: float = randf_range(0.8, 1.0)
	sprite.modulate = Color.from_hsv(hue, sat, val, 1.0)
	#var color: Color = Color.from_ok_hsl(1.5, 0.85, 0.75, 1.0)
	#var foat = color.
