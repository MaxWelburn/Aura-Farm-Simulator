extends Node2D

@export var orb_scene: PackedScene
@export var player: Node2D
@export var max_orbs: int = 100
@export var min_orb_separation: float = 20.0
@export var spawn_radius: float = 900.0
@export var max_spawn_attempts: int = 48
@export var initial_area: Rect2 = Rect2(Vector2(-2000, -2000), Vector2(4000, 4000))
var orbs: Array[Node2D] = []
var sep2: float

func _ready() -> void:
	if orb_scene == null:
		return
	sep2 = min_orb_separation * min_orb_separation
	_seed_initial_pool()
	set_physics_process(true)

func _physics_process(_delta: float) -> void:
	if player == null:
		return
	_despawn_far_orbs()
	_spawn_until_full_near_player()

func _seed_initial_pool() -> void:
	var attempts := 0
	var need: int = maxi(0, max_orbs - orbs.size())
	while orbs.size() < max_orbs and attempts < max_orbs * max_spawn_attempts:
		attempts += 1
		var p := _random_point_in_rect(initial_area)
		if _passes_orb_separation(p, true):
			_spawn_one_at(p)

func _despawn_far_orbs() -> void:
	if player == null:
		return
	for i in range(orbs.size() - 1, -1, -1):
		var o := orbs[i]
		if not is_instance_valid(o):
			orbs.remove_at(i)
			continue
		if o.global_position.distance_to(player.global_position) > spawn_radius:
			orbs.remove_at(i)
			o.queue_free()

func _spawn_until_full_near_player() -> void:
	if player == null:
		return
	while orbs.size() < max_orbs:
		var placed := false
		for _i in max_spawn_attempts:
			var p := _random_point_in_circle(player.global_position, spawn_radius)
			if _passes_orb_separation(p, false):
				_spawn_one_at(p)
				placed = true
				break
		if not placed:
			break

func _spawn_one_at(p: Vector2) -> void:
	var orb := orb_scene.instantiate()
	add_child(orb)
	orb.global_position = p
	orb.name = "Orb"
	orbs.append(orb)
	orb.tree_exited.connect(func():
		for i in range(orbs.size() - 1, -1, -1):
			if not is_instance_valid(orbs[i]):
				orbs.remove_at(i)
	)

func _passes_orb_separation(p: Vector2, is_new) -> bool:
	if not is_new and player != null and p.distance_squared_to(player.global_position) < 1500 * 1500:
		return false
	for i in range(orbs.size() - 1, -1, -1):
		var o := orbs[i]
		if not is_instance_valid(o):
			orbs.remove_at(i)
			continue
		if p.distance_squared_to(o.global_position) < sep2:
			return false
	return true

func _random_point_in_rect(r: Rect2) -> Vector2:
	return Vector2(
		r.position.x + randf() * r.size.x,
		r.position.y + randf() * r.size.y
	)

func _random_point_in_circle(center: Vector2, radius: float) -> Vector2:
	var angle := randf() * TAU
	var r := sqrt(randf()) * radius
	return center + Vector2.RIGHT.rotated(angle) * r
