class_name Player extends CharacterBody2D

@export var default_move_dist: float = 100.0
@export var default_max_speed: float = 1000.0
@export var default_turn_speed: float = 2.0
@export var default_deceleration: float = 2.0
@export var default_acceleration: float = 5.0

@onready var _move_dist: float = default_move_dist
@onready var _max_speed: float = default_max_speed
@onready var _turn_speed: float = default_turn_speed
@onready var _deceleration: float = default_deceleration
@onready var _acceleration: float = default_acceleration

var _target_position: Vector2
var _look_target: Vector2


func _physics_process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	_target_position = mouse_position
	_look_target = mouse_position
	_look_at_target(delta)
	_move_to_target(delta)
	move_and_slide()


func _look_at_target(delta: float) -> void:
	var target_vec := _look_target - position

	if target_vec.length() < 50:
		return

	var target_rotation := lerp_angle(
		rotation,
		atan2(target_vec.y, target_vec.x),
		_turn_speed * delta
	)
	rotation = target_rotation


func _move_to_target(delta: float) -> void:
	var dist_to_target := position.distance_to(_target_position)
	if dist_to_target > _move_dist:
		velocity = transform.x * lerp(0.0, _max_speed, _acceleration * delta)
	else:
		velocity = lerp(velocity, Vector2.ZERO, _deceleration * delta)
