class_name Orb extends Node2D

@export var move_speed: float = 5.0
@export var color_change_speed: float = 5.0
@export var scale_change_speed: float = 0.5
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
var _player_start_size: Vector2


func _ready() -> void:
	var time_now = Time.get_unix_time_from_system() # replaces OS.get_unix_time() in Godot 4
	var seed_value = int(floor(time_now / 100000))
	seed(seed_value)
	randomize()
	var colors: Array[Color] = []
	for i in range(5):
		var hue = float(i) / 5
		var color = Color.from_hsv(hue, 1.0, 1.0)
		colors.append(color)
	sprite.modulate = colors[randi() % colors.size()]
	#var hue: float = randf()
	#var sat: float = randf_range(0.7, 1.0)
	#var val: float = randf_range(0.8, 1.0)
	#sprite.modulate = Color.from_hsv(hue, sat, val, 1.0)


func _process(delta: float) -> void:
	if _getting_absorbed && _color_change_t < 1:
		_color_change_t += color_change_speed * delta
		_scale_change_t += scale_change_speed * delta
		_player_sprite.modulate = lerp(_player_start_color, _player_goal_color, _color_change_t)
		sprite.scale = lerp(sprite.scale, Vector2.ZERO, _scale_change_t)
		_player_sprite.scale = lerp(_player_sprite.scale, _player_sprite.scale * 1.1, _scale_change_t)
	elif _color_change_t >= 1:
		absorbed() # I have been aborbed


func _physics_process(delta: float) -> void:
	if _getting_absorbed && _position_change_t < 1:
		_goal_pos = _player.position
		_position_change_t = move_speed * delta
		position = lerp(position, _goal_pos, _position_change_t)
		 

func start_absorbtion(player: CharacterBody2D) -> void:
	_player = player
	_player_sprite = player.get_node("Sprite2D")
	_player_start_color = _player_sprite.modulate
	_player_goal_color = sprite.modulate
	_player_start_size = _player.scale
	_getting_absorbed = true


func absorbed() -> void:
	_getting_absorbed = false
	_player_sprite.modulate = _player_goal_color
	_player_sprite.global_scale = _player_start_size
	self.queue_free() 


func color_value() : 
	print(sprite.modulate)
	return sprite.modulate
