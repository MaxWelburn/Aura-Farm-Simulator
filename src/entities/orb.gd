class_name Orb extends Node2D

@export var _move_speed: float = 5.0
@export var _color_change_speed: float = 10.0
@export var _scale_change_speed: float = 1.0

@onready var sprite: Sprite2D = $Sprite2D

var _goal_pos: Vector2
var _getting_absorbed: bool = false
var _color_change_t: float = 0.0
var _scale_change_t: float = 0.0
var _position_change_t: float = 0.0
var _player: CharacterBody2D
var _player_sprite: Sprite2D
var _player_start_color: Color
var _player_goal_color: Color


func _ready() -> void:
	var hue: float = randf()
	var sat: float = randf_range(0.7, 1.0)
	var val: float = randf_range(0.8, 1.0)
	sprite.modulate = Color.from_hsv(hue, sat, val, 1.0)
	#var color: Color = Color.from_ok_hsl(1.5, 0.85, 0.75, 1.0)
	#var foat = color.


func _process(delta: float) -> void:
	if _getting_absorbed && _color_change_t < 1:
		_color_change_t += _color_change_speed * delta
		_scale_change_t += _scale_change_speed * delta
		_player_sprite.modulate = lerp(_player_start_color, _player_goal_color, _color_change_t)
		sprite.scale = lerp(sprite.scale, Vector2.ZERO, _scale_change_t)
	elif _color_change_t >= 1:
		absorbed() # I have been aborbed


func _physics_process(delta: float) -> void:
	if _getting_absorbed && _position_change_t < 1:
		_goal_pos = _player.position
		_position_change_t = _move_speed * delta
		position = lerp(position, _goal_pos, _position_change_t)
		 

func start_absorbtion(player: CharacterBody2D) -> void:
	_player = player
	_player_sprite = player.get_node("Sprite2D")
	_player_start_color = Color(_player_sprite.modulate)
	_player_goal_color = Color(sprite.modulate)
	_getting_absorbed = true


func absorbed() -> void:
	_getting_absorbed = false
	_player_sprite.modulate = _player_goal_color
	self.queue_free() 
