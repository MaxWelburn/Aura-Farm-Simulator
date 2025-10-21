class_name Orb extends Node2D

@export var color_change_duration: float = 1.0;
@export var scale_change_duration: float = 0.5;
@export var absorb_threshold: float = 5.0;

@export var curvy: Curve

@onready var sprite: Sprite2D = $Sprite2D

var _getting_absorbed: bool = false
var _player: CharacterBody2D
var _player_sprite: Sprite2D
var _initial_distance: float
var _color_tween: Tween
var _scale_tween: Tween


func _ready() -> void:
	var hue: float = randf()
	var sat: float = randf_range(0.7, 1.0)
	var val: float = randf_range(0.8, 1.0)
	sprite.modulate = Color.from_hsv(hue, sat, val, 1.0)
	#var color: Color = Color.from_ok_hsl(1.5, 0.85, 0.75, 1.0)
	#var foat = color.


func _process(_delta: float) -> void:
	if _getting_absorbed:
		if _color_tween.is_running() && _scale_tween.is_running():
			# if position.distance_to(_player.position) > absorb_threshold:
			# 	var time_left = color_change_duration - _color_tween.get_total_elapsed_time()
			# 	position = lerp(position, _player.position, delta * speed);
			# else:
			# 	position = _player.position
			var current_fraction_complete = _color_tween.get_total_elapsed_time() / color_change_duration
			print(current_fraction_complete)
			var current_distance = _initial_distance * curvy.sample(1 - current_fraction_complete)
			print(current_distance)
			global_position = _player.global_position + (position - _player.global_position).normalized() * current_distance
			
		else:
			_kill() # I have been aborbed


func _exp_decay(a: float, b: float, decay: float, delta) -> float:
	return b + (a - b) * exp(-decay * delta)


func start_absorbtion(player: CharacterBody2D) -> void:
	_player = player
	_player_sprite = player.get_node("Sprite2D")
	_initial_distance = global_position.distance_to(_player.global_position)
	_color_tween = get_tree().create_tween().bind_node(self)
	_scale_tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	_color_tween.tween_property(_player_sprite, "modulate", sprite.modulate, color_change_duration);
	_scale_tween.tween_property(sprite, "scale", Vector2.ZERO, scale_change_duration);
	_getting_absorbed = true


func _kill() -> void:
	self.queue_free()


func color_value() : 
	print(sprite.modulate)
	return sprite.modulate

