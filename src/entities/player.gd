class_name Player extends CharacterBody2D

@export var start_move_distance: float = 100.0
@export var max_speed: float = 800.0
@export var turn_speed: float = 2.0
@export var acceleration: float = 4.0
@export var deceleration: float = 1.0
@export var camera_speed: float = 2.0
@export var magnitude_threshold: float = 100.0
@export var max_camera_offset: float = 200.0
@export var camera: Camera2D
@export var currentColor: Color

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
	

func _look_at_target(delta: float) -> void:
	var target_vec := _look_target - position

	if target_vec.length() < 50:
		return

	var target_rotation := lerp_angle(
		rotation,
		atan2(target_vec.y, target_vec.x),
		turn_speed * delta
	)
	rotation = target_rotation


func _move_to_target(delta: float) -> void:
	var dist_to_target := position.distance_to(_target_position)
	if dist_to_target > start_move_distance:
		velocity = lerp(velocity, transform.x * max_speed, acceleration * delta)
	else:
		velocity = lerp(velocity, Vector2.ZERO, deceleration * delta)


func _update_camera(delta) -> void:
	if _camera_target:
		var goal_offset = Vector2.ZERO
		if _camera_target.velocity.length() >= magnitude_threshold:
			goal_offset = _camera_target.velocity.normalized() * max_camera_offset
		_camera_offset = lerp(_camera_offset, goal_offset, camera_speed * delta)
		camera.position = lerp(camera.position, _camera_target.position + _camera_offset, camera_speed * delta)


func _on_detection_area_area_entered(area: Area2D) -> void:
	var player_sprite = $Sprite2D
	var detected_object = area
	print("detected object: ", detected_object)
	if detected_object.is_in_group("Orbs"):
		var orb: Orb = detected_object
		orb.start_absorbtion(self)
	elif detected_object.is_in_group("Crystal") and player_sprite.modulate != Color(1, 1, 1):
		var crystal: Crystal = detected_object
		var crystal_sprite = crystal.get_node("Sprite2D")
		if crystal_sprite and player_sprite and crystal.color_allowed(player_sprite.modulate):
			print("Color allowed:", player_sprite.modulate)
			var color_tween = create_tween()
			if (crystal_sprite.modulate == Color(1, 1, 1)):
				color_tween.tween_property(crystal_sprite, "modulate", player_sprite.modulate, 0.5)
			else:
				var colormixed = Color.from_ok_hsl(lerp(player_sprite.modulate.ok_hsl_h, crystal_sprite.modulate.ok_hsl_h, 0.5), crystal_sprite.modulate.ok_hsl_s, crystal_sprite.modulate.ok_hsl_l)
				color_tween.tween_property(crystal_sprite, "modulate", colormixed, 0.5)
			player_sprite.modulate = Color(1, 1, 1)
			if crystal.full():
				GameManager.fill_crystal()
				crystal.connected_color_source.show()
				var expansion_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART)
				expansion_tween.tween_property(crystal.connected_color_source, "scale", Vector2.ONE * 10.0, 2.0)
			
			# [OLD, kept in case it comes in handy later for something like scaling saturation slowly] crystal.connected_color_source.material.set_shader_parameter("saturation", 1.0)
		var crystals = get_parent().get_node("Crystals")
		var done = true
		for child in crystals.get_children():
			if child.has_method("full"):
				if !child.full():
					done = false
		if done == true:
			await get_tree().create_timer(1.25).timeout
			game_over()


func game_over() -> void:
	var canvas = get_parent().get_node("CanvasLayer")
	canvas.visible = true
	get_tree().paused = true
