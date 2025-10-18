class_name Orb extends Node2D

@export var _absorb_speed: float = 10.0
@export var _absorb_threshold: float = 5.0

@onready var sprite: Sprite2D = $Sprite2D

var _goal_pos: Vector2
var _getting_absorbed: bool = false
var _player: CharacterBody2D


func _ready() -> void:
	var hue: float = randf()
	var sat: float = randf_range(0.7, 1.0)
	var val: float = randf_range(0.8, 1.0)
	sprite.modulate = Color.from_hsv(hue, sat, val, 1.0)
	#var color: Color = Color.from_ok_hsl(1.5, 0.85, 0.75, 1.0)
	#var foat = color.


func _physics_process(delta: float) -> void:
	if _getting_absorbed and position.distance_to(_goal_pos) > _absorb_threshold:
		_goal_pos = _player.position
		position = lerp(position, _goal_pos, _absorb_speed * delta)
	elif _getting_absorbed and position.distance_to(_goal_pos) <= _absorb_threshold:
		absorbed() # I have been aborbed
		 

func start_absorbtion(player: CharacterBody2D) -> void:
	_player = player
	_getting_absorbed = true


func absorbed() -> void:
	_getting_absorbed = false
	var player_sprite = _player.get_node("Sprite2D")
	var orb_sprite = $Sprite2D
	if (player_sprite and orb_sprite):
		player_sprite.modulate = orb_sprite.modulate
		print("Changed player color to:", orb_sprite.modulate)
	self.queue_free() 
