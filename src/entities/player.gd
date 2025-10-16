class_name Player extends CharacterBody2D

@export var default_move_dist: float = 100.0
@export var default_max_speed: float = 1000.0
@export var default_turn_speed: float = 2.0
@export var default_deceleration: float = 2.0
@export var default_acceleration: float = 5.0
@export var camera_speed: float = 2.0
@export var magnitude_threshold: float = 100.0
@export var max_camera_offset: float = 200.0
@export var camera: Camera2D
@export var currentColor: Color

@onready var _move_dist: float = default_move_dist
@onready var _max_speed: float = default_max_speed
@onready var _turn_speed: float = default_turn_speed
@onready var _deceleration: float = default_deceleration
@onready var _acceleration: float = default_acceleration

var _target_position: Vector2
var _look_target: Vector2
var _camera_target: CharacterBody2D
var _camera_offset: Vector2

func _process(delta: float) -> void:
	_update_camera(delta)

func _physics_process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	_target_position = mouse_position
	_look_target = mouse_position
	_camera_target = self
	_look_at_target(delta)
	_move_to_target(delta)
	move_and_slide()
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider is CharacterBody2D:
			var player_sprite = $Sprite2D
			if collider.name.find("Orb") != -1:
				var orb_sprite = collider.get_node("Sprite2D")
				if orb_sprite and player_sprite:
					player_sprite.modulate = orb_sprite.modulate
					print("Changed player color to:", orb_sprite.modulate)
				collider.queue_free()
			elif collider.name.find("Crystal") != -1 and player_sprite.modulate != Color(1, 1, 1):
				var crystal_sprite = collider.get_node("Sprite2D")
				if crystal_sprite and player_sprite:
					crystal_sprite.modulate = player_sprite.modulate
					player_sprite.modulate = Color(1, 1, 1)

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

func _update_camera(delta) -> void:
	if _camera_target:
		var goal_offset = Vector2.ZERO
		if _camera_target.velocity.length() >= magnitude_threshold:
			goal_offset = _camera_target.velocity.normalized() * max_camera_offset
		_camera_offset = lerp(_camera_offset, goal_offset, camera_speed * delta)
		camera.position = lerp(camera.position, _camera_target.position + _camera_offset, camera_speed * delta)
